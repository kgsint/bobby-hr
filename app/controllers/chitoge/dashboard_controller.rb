module Chitoge
  class DashboardController < BaseChitogeController
    layout 'admin'

    def index
      if current_user.ghost_admin?
        @total_departments = Department.count
        @total_companies = Company.count
      end

      if current_user.company_admin?
        @leave_requests = LeaveRequest.all
        @pending_leave_requests = LeaveRequest.all.where(status: 'pending')
        @total_leaves_count = LeaveRequest.with_current_company.count
        @total_employees = Employee.with_current_company.count
        @total_late = Attendance.with_current_company.where(status: 'late').count

        @late_by_department = Attendance
        .with_current_company
        .where(status: 'late')
        .joins(employee: :department)
        .group('departments.name')
        .count
      end
    end
  end

end