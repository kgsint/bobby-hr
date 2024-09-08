module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private
    def authenticate_user
      if user = User.where(id: session[:user_id]).first
        Current.user = user
      else
        redirect_to login_path
      end
    end

    def guest_user_only
      user = User.where(id: session[:user_id]).first
      if user
        redirect_to root_path
      end
    end

    def login(user)
      Current.user = user
      reset_session
      session[:user_id] = user.id
    end

    def logout
      Current.user = nil
      reset_session
    end
end
