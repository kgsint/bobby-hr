module Chitoge
  class DashboardController < BaseChitogeController
    layout 'admin'

    def index
      @total_employees = Employee.count
      @total_departments = Department.count
      @total_companies = Company.count
    end
  end

end
