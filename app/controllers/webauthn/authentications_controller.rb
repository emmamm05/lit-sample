class Webauthn::AuthenticationsController < ApplicationController
  skip_before_action :authenticate, only: [:options, :create]

  def options
    # Allow username-less flow by accepting email hint or discovering credentials
    user = User.find_by(email: params[:email].to_s.strip.downcase) if params[:email].present?

    allowed = user ? user.webauthn_credentials.pluck(:external_id) : []

    options = WebAuthn::Credential.options_for_get(
      allow: allowed.presence
    )
    session[:webauthn_authentication_challenge] = options.challenge
    session[:webauthn_auth_user_id] = user&.id
    render json: options
  end

  def create
    challenge = session.delete(:webauthn_authentication_challenge)
    return head :unprocessable_entity unless challenge

    cred = WebAuthn::Credential.from_get(params.require(:credential))

    # If we scoped to a user earlier, use it; otherwise look up by credential id
    user_id = session.delete(:webauthn_auth_user_id)
    user = User.find_by(id: user_id) if user_id
    user ||= User.joins(:webauthn_credentials).where(webauthn_credentials: { external_id: cred.id }).first

    return render json: { ok: false, error: "Credential not found" }, status: :unprocessable_entity unless user

    record = user.webauthn_credentials.find_by(external_id: cred.id)

    cred.verify(challenge, public_key: record.public_key, sign_count: record.sign_count, rp_id: request.host)

    # Update sign count
    record.update!(sign_count: cred.sign_count)

    # Establish session (respect 2FA if enabled? For simplicity, treat as strong auth bypassing TOTP)
    session_record = user.sessions.create!
    cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

    render json: { ok: true }
  rescue WebAuthn::Error => e
    render json: { ok: false, error: e.message }, status: :unprocessable_entity
  end
end
