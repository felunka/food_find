class RegistrationToken < ApplicationRecord
  has_secure_token :auth_token

  before_create :set_auth_token

  private

  def set_auth_token
    self.auth_token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(10)
      break token unless RegistrationToken.where(auth_token: token).exists?
    end
  end
end
