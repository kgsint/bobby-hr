module Chitoge
  class DashboardController < BaseChitogeController
    layout 'admin'

    def index
      @total_employees = Employee.count
    end
  end

end
