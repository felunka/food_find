class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :callback]

  def new
  end

  def create
    user = User.find_by(username: session_params[:username])

    if user
      get_options = WebAuthn::Credential.options_for_get(allow: user.credentials.pluck(:external_id))

      session[:current_authentication] = { challenge: get_options.challenge, username: session_params[:username] }

      respond_to do |format|
        format.json { render json: get_options }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: ['Username does not exist'] }, status: :unprocessable_entity }
      end
    end
  end

  def callback
    webauthn_credential = WebAuthn::Credential.from_get(params)

    user = User.find_by(username: session['current_authentication']['username'])

    raise "user #{session['current_authentication']['username']} never initiated sign up" unless user

    credential = user.credentials.find_by(external_id: Base64.strict_encode64(webauthn_credential.raw_id))

    begin
      webauthn_credential.verify(
        session['current_authentication']['challenge'],
        public_key: credential.public_key,
        sign_count: credential.sign_count
      )

      credential.update!(sign_count: webauthn_credential.sign_count)
      session[:user_id] = user.id

      render json: { status: 'ok' }, status: :ok
    rescue WebAuthn::Error => e
      render json: "Verification failed: #{e.message}", status: :unprocessable_entity
    ensure
      session.delete('current_authentication')
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to action: 'new'
  end

  private

  def session_params
    params.require(:session).permit(:username)
  end
end
