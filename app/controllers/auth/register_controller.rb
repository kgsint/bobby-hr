class Auth::RegisterController < ApplicationController
  layout 'auth'
  before_action :set_user, only: :create

  def new
    @user = User.new
  end

  def create
    if @user.save
      flash[:notice] = "user has been created"

      redirect_to log_in_path
    end
  end

  private

  def set_user
    @user = User.new(user_params.except :confirm_password)
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :confirm_password, :company_id)
  end
end
