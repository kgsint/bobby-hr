class ApplicationController < ActionController::Base
  include Authentication

  helper_method :current_user

  private
  

  def current_user
    Current.user
  end

  def current_employee
    if current_user && current_user.email
      @current_employee ||= Employee.find_by(email: current_user.email)
    end
  end

end
