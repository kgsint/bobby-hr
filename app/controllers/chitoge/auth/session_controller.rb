class Chitoge::Auth::SessionController < Chitoge::Auth::BaseAuthenticationController
  before_action :redirect_if_authenticated, except: :destroy

  def new

  end

  def create
    user = User.authenticate_by(email: params[:email], password: params[:password])
    if user && user.ghost_admin?
        login(user)
        redirect_to chitoge_ghost_admin_dashboard_path
    else
      flash[:old_email] = params[:email]
      flash[:error] = "The provided credentials do not match."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout

    redirect_to login_path
  end
end
