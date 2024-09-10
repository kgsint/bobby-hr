class Auth::RegisterController < Auth::BaseAuthenticationController

  before_action :set_user, only: :create
  before_action :redirect_if_authenticated

  def new
    @user = User.new
  end

  def create
    if @user.save
      flash[:notice] = "user has been created"

      redirect_to login_path
    else
      render :new, status: :unprocessable_entity
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
