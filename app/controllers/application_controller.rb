class ApplicationController < ActionController::Base
  before_action :require_login

  helper_method :current_user

  private

  def current_user
    @current_user ||=
      if session[:user_id]
        User.find_by(id: session[:user_id])
      end
  end

  def require_login
    unless current_user
      redirect_to new_session_path
    end
  end
end
