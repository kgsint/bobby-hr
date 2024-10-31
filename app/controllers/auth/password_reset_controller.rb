class Auth::PasswordResetController < ApplicationController
  layout 'auth'
  skip_before_action :authenticate_user

  def new
    email = params[:email]
    token = params[:token]
    password_reset = PasswordReset.find_by(email: email)

    if !email || password_reset.nil?
      not_found
    end
    # validate token
    if password_reset.token != params[:token]
      not_found
    end
  end

  def create
    password = params[:password]
    email = params[:email]

    User.find_by(email: email).update({password: params[:password]})

    redirect_to login_path

  end

  private
    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

end
