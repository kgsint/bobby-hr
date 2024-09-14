class ResetPasswordMailer < ApplicationMailer
  def send_reset_password
    mail(to: params[:user].email, subject: 'Reset Password URL')
  end
end
