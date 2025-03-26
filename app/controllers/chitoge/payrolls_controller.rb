class Chitoge::PayrollsController < ApplicationController
  before_action :set_payroll, only: %i[ show edit update destroy ]
  before_action :set_employee, only: [:new, :create]

  # GET /payrolls or /payrolls.json
  def index
    # @employees = Employee.includes(:payrolls).all 
    @payrolls = Payroll.all
  end

  # GET /payrolls/1 or /payrolls/1.json
  def show
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
    pay_date = Date.today.end_of_month
    payroll_service = PayrollService.new(employee, pay_date)
    payroll_service.generate_payroll

    redirect_to chitoge_payrolls_path, notice: "Payroll generated successfully."
  rescue ActiveRecord::RecordNotFound
    redirect_to new_chitoge_payroll_path, alert: "Employee not found."
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
      params.require(:payroll).permit(:employee_id, :pay_date, :gross_pay, :net_pay, :tax_deductions, :benefits_deductions, :other_deductions)
    end
end
