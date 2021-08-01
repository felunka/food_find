class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    token = RegistrationToken.find_by(auth_token: params[:registration][:token])

    if token
      create_options = WebAuthn::Credential.options_for_create(
        user: {
          id: WebAuthn.generate_user_id,
          name: token.auth_token
        }
      )
      session[:current_registration] = { challenge: create_options.challenge, token: token.auth_token }

      respond_to do |format|
        format.json { render json: create_options }
      end
    else
      render json: 'Verification failed: Invalid token', status: :unprocessable_entity
    end
  end

  def callback
    webauthn_credential = WebAuthn::Credential.from_create(params)

    begin
      webauthn_credential.verify(session['current_registration']['challenge'])

      credential = Credential.new(
        external_id: Base64.strict_encode64(webauthn_credential.raw_id),
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      )

      if credential.save
        session[:logged_in] = true

        render json: { status: 'ok' }, status: :ok
      else
        render json: 'Could not register your Security Key', status: :unprocessable_entity
      end
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_entity
    ensure
      RegistrationToken.find_by(auth_token: session['current_registration']['token']).destroy
      session.delete('current_registration')
    end
  end
end
