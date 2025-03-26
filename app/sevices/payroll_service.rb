class PayrollService
  DEFAULT_TAX_RATE = 0.1
  DEFAULT_BENEFITS_RATE = 0
  LATE_PENALTY_PER_DAY = 1500 

  def initialize(employee, pay_date, tax_rate: DEFAULT_TAX_RATE, benefits_rate: DEFAULT_BENEFITS_RATE)
    @employee = employee
    @pay_date = pay_date
    @tax_rate = tax_rate
    @benefits_rate = benefits_rate
  end

  def generate_payroll
    raise ArgumentError, "Employee is required" unless @employee
    raise ArgumentError, "Pay date is required" unless @pay_date

    gross_pay = calculate_gross_pay
    deductions = calculate_deductions(gross_pay)
    net_pay = gross_pay - deductions.values.sum

    Payroll.create!(
      employee_id: @employee.id,
      pay_date: @pay_date,
      gross_pay: gross_pay,
      net_pay: net_pay,
      tax_deductions: deductions[:tax],
      benefits_deductions: deductions[:benefits],
      other_deductions: deductions[:other]
    )
  rescue => e
    Rails.logger.error "Payroll generation failed: #{e.message}"
    raise
  end

  private

  def calculate_gross_pay
    if @employee.salary.present?
      @employee.salary
    else
      calculate_hourly_pay
    end
  end

  def calculate_hourly_pay
    hours_worked = calculate_hours_worked
    raise "Hourly rate not set for employee" unless @employee.hourly_rate.present?
    @employee.hourly_rate * hours_worked
  end

  def calculate_hours_worked
    # More flexible date range handling
    start_date = @pay_date.beginning_of_month
    end_date = @pay_date.end_of_month
    
    @employee.attendances
             .where(date: start_date..end_date)
             .sum(:hours_worked)
  end

  def calculate_deductions(gross_pay)
    {
      tax: gross_pay * @tax_rate,
      benefits: gross_pay * @benefits_rate,
      other: calculate_other_deductions
    }
  end

  def calculate_other_deductions
    # Fetch all late attendances for the month
    late_attendances = @employee.attendances
                                .where(
                                  date: @pay_date.beginning_of_month..@pay_date.end_of_month,
                                  status: 'late'  # Check for 'late' status
                                )
    
    # Calculate total penalty: ₹500 per late attendance
    late_attendances.count * LATE_PENALTY_PER_DAY
  end
end