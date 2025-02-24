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

  def update
    @employee = Employee.find(params[:id])
    if @employee.update(employee_params)
      redirect_to chitoge_employees_path, notice: 'Employee was successfully updated.'
    end
  end

  def show
    @employee = Employee.find_by(id: params[:id])
    if @employee
      respond_to do |format|
        format.html 
        format.json { render json: @employee } 
      end
    else
      respond_to do |format|
        format.html { redirect_to chitoge_employees_path, alert: "Employee not found." }
        format.json { render json: { error: "Employee not found" }, status: :not_found }
      end
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    respond_to do |format|
      format.json { render json: { message: "Employee was successfully deleted." }, status: :ok }
    end
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name,:email,:phone_number,:job_title,:company_id,:hire_at,:department_id,:salary,:hourly_rate)
  end
end
