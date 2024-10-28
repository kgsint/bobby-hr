class Auth::PasswordResetController < ApplicationController
  skip_before_action :authenticate_user

  def new
    email = params[:email]
    token = params[:token]
    password_reset = PasswordReset.find_by(email: email)

    if !email || password_reset.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    if password_reset.token != params[:token]
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
