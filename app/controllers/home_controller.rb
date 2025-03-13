class HomeController < ApplicationController
  def index
    @total_employees = Employee.with_current_company.count
  end

  def show
    @employee = Employee.find_by(email: current_user.email)
  end
end
