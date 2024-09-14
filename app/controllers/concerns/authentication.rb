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

    def login(user)
      Current.user = user
      reset_session
      session[:user_id] = user.id

      set_last_login_at
    end

    def logout
      Current.user = nil
      reset_session
    end

    def set_last_login_at
      Current.user.update(last_login_at: DateTime.now)
    end

    def redirect_if_authenticated
      if session[:user_id] && User.find(session[:user_id])
        redirect_to root_path
      end
    end
end
