class Chitoge::PayrollsController < ApplicationController
  before_action :set_payroll, only: %i[ show edit update destroy ]
  before_action :set_employee, only: [:new, :create]

  # GET /payrolls or /payrolls.json
  def index
    @employees = Employee.includes(:payrolls).all 
    @payrolls = Payroll.all
  end

  # GET /payrolls/1 or /payrolls/1.json
  def show
    @employee = current_employee
    @payroll = Payroll.find(params[:id])
  end

  # GET /payrolls/new
  def new
    @payroll = Payroll.new
    @employees = Employee.with_current_company 
  end

  # GET /payrolls/1/edit
  def edit  
  end

  def employee_payrolls
    @employee = Employee.find(params[:employee_id])
    @payrolls = @employee.payrolls.order(pay_date: :desc)
  end

  # POST /payrolls or /payrolls.json
  def create
    employee = Employee.find(params[:employee_id])
    pay_date = Date.current.end_of_month
  
    existing_payroll = employee.payrolls
                             .where('pay_date BETWEEN ? AND ?', 
                                   pay_date.beginning_of_month,
                                   pay_date.end_of_month)
                             .first
  
    if existing_payroll
      redirect_to chitoge_payrolls_path, 
                  alert: "Payroll already exists for #{employee.name} (#{pay_date.strftime('%B %Y')})"
      return
    end
  
    # Only generate if no existing payroll
    payroll = PayrollService.new(employee, pay_date).generate_payroll
    redirect_to chitoge_payrolls_path,
                notice: "Successfully generated payroll for #{employee.name} (#{pay_date.strftime('%B %Y')})"
  
  rescue ActiveRecord::RecordNotFound
    redirect_to chitoge_payrolls_path, alert: "Employee not found"
  rescue => e
    redirect_to chitoge_payrolls_path, alert: "Payroll generation failed: #{e.message}"
  end

  def bulk_create
    pay_date = parse_pay_date(params[:pay_date])
    
    employees = Employee.with_current_company 
    generated_count = 0
    skipped_count = 0
  
    employees.find_each do |employee|
      payroll = PayrollService.new(employee, pay_date).generate_payroll
      payroll.persisted? ? generated_count += 1 : skipped_count += 1
    end
   
    redirect_to chitoge_payrolls_path,  notice: "Generated payrolls, skipped #{skipped_count} duplicates"
  rescue => e
    redirect_to chitoge_payrolls_path, alert: "Error: #{e.message}"
  end
  
  # def create
  #   employee = Employee.find(params[:employee_id])
  #   pay_date = params[:pay_date].to_date

  #   payroll_calculator = PayrollCalculator.new(employee, pay_date)
  #   payroll_data = payroll_calculator.calculate

  #   payroll = employee.payrolls.create!(
  #     pay_date: pay_date,
  #     gross_pay: payroll_data[:gross_pay],
  #     net_pay: payroll_data[:net_pay],
  #     tax_deductions: payroll_data[:tax_deductions],
  #     benefits_deductions: payroll_data[:benefits_deductions],
  #     other_deductions: payroll_data[:other_deductions]
  #   )

  #   redirect_to payroll_path(payroll), notice: "Payroll generated successfully."
  # end

  # PATCH/PUT /payrolls/1 or /payrolls/1.json
  def update
    respond_to do |format|
      if @payroll.update(payroll_params)
        format.html { redirect_to payroll_url(@payroll), notice: "Payroll was successfully updated." }
        format.json { render :show, status: :ok, location: @payroll }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payrolls/1 or /payrolls/1.json
  def destroy
    @payroll.destroy!

    respond_to do |format|
      format.html { redirect_to payrolls_url, notice: "Payroll was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_employee
      @employee = Employee.find_by(id: params[:employee_id]) if params[:employee_id].present?
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payroll_params
      params.require(:payroll).permit(:employee_id, :pay_date, :gross_pay, :net_pay, :tax_deductions, :leave_deductions, :other_deductions)
    end

    def parse_pay_date(date_string)
      date_string.present? ? Date.parse(date_string) : Date.current
    rescue Date::Error
      Date.current
    end
end
