module Chitoge
  class EmployeesController < ApplicationController
    before_action :require_admin_authority

    def index
      @employees = Employee.with_current_company
    end

    def show
      byebug
      @employee = Employee.find_by(id: params[:id])
      if @employee
        @attendances = @employee.attendances.order(created_at: :desc) # Fetch attendance records
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

    def new
      @employee = Employee.new
    end

    def create
      @employee = Employee.new(employee_params.except(:password))

      @user = User.new(
        name: employee_params[:name],
        email: employee_params[:email],
        password_digest: BCrypt::Password.create(employee_params[:password]),
        company_id: employee_params[:company_id],
        role: "employee",
        last_login_at: Time.now
      )

      if @user.save! && @employee.save
        redirect_to employees_path, notice: 'Employee was successfully created.'
      else
        render :new
      end
    end

    def edit
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

    def update
      @employee = Employee.find_by(id: params[:id])
      @user = User.find_by(email: @employee.email)

      if @employee && @user
        @user.name = employee_params[:name].present? ? employee_params[:name] : @user.name
        @user.email = employee_params[:email].present? ? employee_params[:email] : @user.email
        @user.password_digest = employee_params[:password].present? ?
                                  BCrypt::Password.create(employee_params[:password]) :
                                  @user.password_digest
        @user.date_of_birth = employee_params[:date_of_birth].present? ? employee_params[:date_of_birth] : @user.date_of_birth

        if @employee.update!(employee_params.except(:password)) && @user.save!
          redirect_to employees_path, notice: 'Employee was successfully updated.'
        else
          render :edit
        end
      else
        flash[:alert] = "Employee not found."
        redirect_to employees_path
      end
    end

    def destroy
      @employee = Employee.find(params[:id])
      @employee.destroy
      respond_to do |format|
        format.html { redirect_to chitoge_employees_path, notice: 'Employee was successfully deleted.' }
        format.json { render json: { message: "Employee was successfully deleted." }, status: :ok }
      end
    end

    def employee_params
      params
          .require(:employee)
          .permit(
            :name,
            :email,
            :phone_number,
            :job_title,
            :company_id,
            :hire_at,
            :department_id,
            :salary,
            :hourly_rate,
            :date_of_birth,
            :password,
          )
    end

    private
      def require_admin_authority
        if !current_user.company_admin?
          flash[:alert] = "You are not authorized to perform this action."
          redirect_to "/404.html"
        end
      end
  end

end
