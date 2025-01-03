class Chitoge::EmployeesController < ApplicationController
  layout 'admin'

  def index
    @employees = Employee.all
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to chitoge_employees_path, notice: 'Employee was successfully created.'
    else
      render :new
    end
  end

  def edit
    @employee = Employee.find_by(id: params[:id])

    unless @employee
      flash[:alert] = "Employee not found."
      redirect_to chitoge_employees_path
    end
  end

  def show
    @employee = Employee.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to employees_path, alert: "Employee not found."
  end

  def destroy
    @employee = Employee.find_by(id: params[:id])
  
    if @employee
      @employee.destroy
      redirect_to chitoge_employees_path, notice: 'Employee was successfully deleted.'
    else
      redirect_to chitoge_employees_path, alert: 'Employee not found.'
    end
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name,:email,:phone_number,:job_title,:company_id,:hire_at,:department_id,:salary,:hourly_rate)
  end
end
