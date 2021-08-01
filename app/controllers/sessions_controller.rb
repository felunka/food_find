class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :callback]

  def new
  end

  def create
    get_options = WebAuthn::Credential.options_for_get(allow: Credential.all.pluck(:external_id))

    session[:current_authentication] = { challenge: get_options.challenge }

    respond_to do |format|
      format.json { render json: get_options }
    end
  end

  def callback
    webauthn_credential = WebAuthn::Credential.from_get(params)

    credential = Credential.find_by(external_id: Base64.strict_encode64(webauthn_credential.raw_id))

    begin
      webauthn_credential.verify(
        session['current_authentication']['challenge'],
        public_key: credential.public_key,
        sign_count: credential.sign_count
      )

      credential.update!(sign_count: webauthn_credential.sign_count)
      session[:logged_in] = true

      render json: { status: 'ok' }, status: :ok
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_entity
    ensure
      session.delete('current_authentication')
    end
  end

  def destroy
    session[:logged_in] = nil

    redirect_to action: 'new'
  end
end
