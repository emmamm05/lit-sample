class User < ApplicationRecord
  has_secure_password

  has_many :webauthn_credentials, dependent: :destroy

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  # ==== Two-factor authentication (TOTP + backup codes) ====
  def otp_enabled?
    otp_enabled_at.present?
  end

  def enable_otp!
    update!(otp_secret: ROTP::Base32.random_base32, otp_enabled_at: Time.current) unless otp_enabled?
  end

  def disable_otp!
    update!(otp_secret: nil, otp_enabled_at: nil, otp_backup_codes: nil)
  end

  def totp
    raise "OTP secret not set" if otp_secret.blank?
    ROTP::TOTP.new(otp_secret, issuer: Rails.application.class.module_parent_name)
  end

  def verify_totp(code)
    return false if otp_secret.blank?
    # allow drift for better UX
    !!totp.verify(code.to_s.delete(" \t-"), drift_ahead: 30, drift_behind: 30)
  end

  def generate_backup_codes!
    codes = Array.new(10) { SecureRandom.base58(10) }
    digests = codes.map { |c| BCrypt::Password.create(c) }
    update!(otp_backup_codes: digests.to_json)
    codes
  end

  def backup_codes
    return [] if otp_backup_codes.blank?
    JSON.parse(otp_backup_codes)
  end

  def consume_backup_code!(code)
    return false if otp_backup_codes.blank?
    current = backup_codes
    index = current.find_index { |digest| BCrypt::Password.new(digest) == code.to_s }
    return false unless index
    current.delete_at(index)
    update!(otp_backup_codes: current.to_json)
    true
  end
  # WebAuthn user handle; generate if missing
  def ensure_webauthn_id!
    return webauthn_id if webauthn_id.present?
    update!(webauthn_id: WebAuthn.respond_to?(:generate_user_id) ? WebAuthn.generate_user_id : SecureRandom.hex(32))
    webauthn_id
  end
end
