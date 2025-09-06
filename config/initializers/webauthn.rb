WebAuthn.configure do |config|
  # Relying Party (your application) name
  config.relying_party.name = Rails.application.class.module_parent_name

  # In production, set this to your domain (without scheme). For tests/dev, allow dynamic rp_id.
  # We'll derive rp_id from requests unless explicitly set elsewhere.
  # config.relying_party.id = "#{Rails.application.credentials.dig(:webauthn, :rp_id)}" if Rails.application.credentials.dig(:webauthn, :rp_id)

  # Origins allowed to make WebAuthn requests. In tests, Rails uses http://www.example.com
  origins = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://www.example.com"
  ]
  if Rails.env.production? && ENV["WEBAUTHN_ORIGIN"].present?
    origins << ENV["WEBAUTHN_ORIGIN"]
  end
  config.origin = origins

  # Algorithm preferences; defaults are fine for modern browsers.
  # config.algorithms = ["ES256", "RS256"]
end
