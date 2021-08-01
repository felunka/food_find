class RegistrationTokensController < ApplicationController
  def index
    @tokens = RegistrationToken.all
  end

  def create
    RegistrationToken.create
    flash[:success] = 'Token created'
    redirect_to action: 'index'
  end

  def destroy
    RegistrationToken.find_by(params.permit(:id)).destroy
    flash[:danger] = 'Tag deleted'
    redirect_to action: 'index'
  end
end
  