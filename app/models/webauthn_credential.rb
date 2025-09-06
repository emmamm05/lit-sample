class WebauthnCredential < ApplicationRecord
  belongs_to :user

  validates :external_id, presence: true, uniqueness: true
  validates :public_key, presence: true

  def authenticator
    @authenticator ||= WebAuthn::Authenticator.from_public_key(public_key)
  end
end
