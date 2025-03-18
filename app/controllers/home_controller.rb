class HomeController < ApplicationController
  def index
    @total_employees = Employee.with_current_company.count
  end

  def show
    if current_user.company_admin? || current_user.employee?
      @employee = Employee.find_by(email: current_user.email)
      @total_leaves = @employee.leave_requests.where.not(approved_at: nil).count
      @attendances = @employee.attendances
    end
  end
end
