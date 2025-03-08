class Chitoge::DashboardController < ApplicationController
  layout 'admin'
  def index
    @total_employees = Employee.count
  end
end
