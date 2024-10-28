class Auth::ForgetPasswordController < ApplicationController
  layout 'auth'
  skip_before_action :authenticate_user

  def new

  end

 def create
  user = User.find_by(email: params[:email])

  if user
    password_reset = PasswordReset.new
    password_reset.email = params[:email]
    password_reset.token = SecureRandom.hex(10)
    password_reset.save

    ResetPasswordMailer.with(user: user).send_reset_password.deliver_now
  end
  flash[:notice] = 'Password reset email has been sent!'
  render :new
  # flash.now[:alert] = 'Email address not found'
 end

 private
  def password_reset_params
    params.require(:password_reset).permit(:email, :token, :created_at)
  end
end
