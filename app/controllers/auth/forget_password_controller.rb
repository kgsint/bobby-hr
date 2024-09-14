class Auth::ForgetPasswordController < ApplicationController
  layout 'auth'
  skip_before_action :authenticate_user
 def new
  
 end

 def create
  user = User.find_by(email: params[:email])

  if user
    ResetPasswordMailer.with(user: user).send_reset_password.deliver_now
    flash[:notice] = 'Password reset email has been sent!'
    redirect_to forget_password_path 
  else
    flash.now[:alert] = 'Email address not found'
    render :new
  end
 end

end
