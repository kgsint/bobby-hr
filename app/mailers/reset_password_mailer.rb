class ResetPasswordMailer < ApplicationMailer
  def send_reset_password
    @user = params[:user]
    @token = PasswordReset.find_by(email: @user.email).token
    @reset_password_url = "http://localhost:3000/reset-password/#{@token}?email=#{@user.email}"
    mail(to: params[:user].email, subject: 'Reset Password URL')
  end
end
