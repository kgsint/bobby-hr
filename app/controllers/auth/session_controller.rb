class Auth::SessionController < Auth::BaseAuthenticationController

  before_action :redirect_if_authenticated, except: :destroy

  def new

  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      login(user)

      redirect_by_role(user)
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

  private
    def redirect_by_role(user)
      case user.role
      when 'ghost_admin'
        redirect_to chitoge_dashboard_path
      when 'company_admin'
        redirect_to chitoge_dashboard_path
      when 'employee'
        redirect_to profile_path
      end
    end
end
