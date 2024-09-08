class Auth::SessionController < ApplicationController
  layout 'auth'

  skip_before_action :authenticate_user

  def new

  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      login(user)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout

    redirect_to login_path
  end
end
