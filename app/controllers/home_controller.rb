class HomeController < ApplicationController
  def index
    @total_employees = Employee.with_current_company.count
  end

  def show
    @employee = Employee.find_by(email: current_user.email)
    if current_user.company_admin? || current_user.employee?
      @employee = Employee.find_by(email: current_user.email)
      @total_leaves = @employee.leave_requests.count
      @attendances = @employee.attendances
      # Fetch all leave requests for the employee, ordered by creation date (newest first)
      @leave_requests = @employee.leave_requests.order(created_at: :desc)
      @approved_leaves = @employee.leave_requests.where(status: 'approved').count
      @declined_leaves = @employee.leave_requests.where(status: 'declined').count
      @pending_leaves = @employee.leave_requests.where(status: 'pending').count


      # Fetch the latest leave request
      @latest_leave_request = @leave_requests.first
    end
  end
end
