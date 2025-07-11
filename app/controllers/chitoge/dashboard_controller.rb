module Chitoge
  class DashboardController < BaseChitogeController
    layout 'admin'

    def index
      if current_user.ghost_admin?
        @total_departments = Department.count
        @total_companies = Company.count
      end

      if current_user.company_admin?
        @leave_requests = LeaveRequest.with_current_company.all
        @pending_leave_requests = LeaveRequest.with_current_company.all.where(status: 'pending')
        @total_leaves_count = LeaveRequest.with_current_company.count
        @total_employees = Employee.with_current_company.count
        @total_late = Attendance.with_current_company.where(status: 'late').count
        @employees = Employee.all
  
        # Apply filters
        if params[:status].present?
          case params[:status]
          when 'healthy'
            @employees = @employees.where("casual_leave_balance > 5 AND sick_leave_balance > 5")
          when 'low'
            @employees = @employees.where("(casual_leave_balance BETWEEN 1 AND 5) OR (sick_leave_balance BETWEEN 1 AND 5)")
          when 'critical'
            @employees = @employees.where("casual_leave_balance = 0 OR sick_leave_balance = 0")
          when 'negative'
            @employees = @employees.where("casual_leave_balance < 0 OR sick_leave_balance < 0")
          end
        end
        
        # Apply search
        if params[:search].present?
          @employees = @employees.where("name ILIKE ?", "%#{params[:search]}%")
        end
        
        # Apply sorting
        sort_column = params[:sort] || 'name'
        sort_direction = params[:direction] || 'asc'
        @employees = @employees.order("#{sort_column} #{sort_direction}")
        
        # Paginate with Kaminari
        @employees = @employees.page(params[:page]).per(25)
      
        @department_with_company = Department.with_current_company.joins(:employees, :company)
                                            .group('departments.name', 'companies.name')
        

        @department_with_company = Department.with_current_company.joins(:employees, :company)
        .group('departments.name', 'companies.name')
        .count

        @late_by_department = Attendance
        .with_current_company
        .where(status: 'late')
        .joins(employee: :department)
        .group('departments.name')
        .count

          # Add these payroll queries
        current_period = Date.today.beginning_of_month..Date.today.end_of_month
        @payroll_summary = {
          total_processed: Payroll.where(pay_date: current_period).sum(:net_pay),
          employees_paid: Payroll.where(pay_date: current_period).count,
          average_net: Payroll.where(pay_date: current_period).average(:net_pay).to_f
        }

        @payroll_trends = (0..2).to_a.reverse.each_with_object({}) do |i, hash|
          date = (Date.today - i.months)
          period = date.beginning_of_month..date.end_of_month
          payrolls = Payroll.where(pay_date: period)
          hash[date.strftime('%b %Y')] = {
            gross_pay: payrolls.sum(:gross_pay),
            net_pay: payrolls.sum(:net_pay)
          }
        end
      end
    end
  end

end