class Identity::Webauthn::RegistrationsController < ApplicationController
  def options
    user = Current.user
    user.ensure_webauthn_id!

    options = WebAuthn::Credential.options_for_create(
      user: { id: user.webauthn_id, name: user.email },
      exclude: user.webauthn_credentials.pluck(:external_id)
    )

    session[:webauthn_registration_challenge] = options.challenge

    render json: options
  end

  def create
    user = Current.user
    challenge = session.delete(:webauthn_registration_challenge)
    return head :unprocessable_entity unless challenge

    webauthn_credential = WebAuthn::Credential.from_create(params.require(:credential))

    verification = webauthn_credential.verify(
      challenge,
      user_verification: "preferred",
      rp_id: request.host
    )

    credential = user.webauthn_credentials.create!(
      external_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count,
      nickname: params[:nickname].presence
    )

    render json: { ok: true, id: credential.id }
  rescue WebAuthn::Error => e
    render json: { ok: false, error: e.message }, status: :unprocessable_entity
  end
end
