class PayrollService
  DEFAULT_TAX_RATE = 0.1
  DEFAULT_LEAVE_RATE = 0
  LATE_PENALTY_PER_DAY = 1500 

  def initialize(employee, pay_date, tax_rate: DEFAULT_TAX_RATE, leave_rate: DEFAULT_LEAVE_RATE)
    @employee = employee
    @pay_date = pay_date
    @tax_rate = tax_rate
    @leave_rate = leave_rate
  end

  def generate_payroll
    raise ArgumentError, "Employee is required" unless @employee
    raise ArgumentError, "Pay date is required" unless @pay_date
    
    @pay_date = @pay_date.is_a?(String) ? Date.parse(@pay_date) : @pay_date
  
    existing_payroll = find_existing_payroll
    if existing_payroll
      Rails.logger.warn "Payroll exists for #{@employee.name} in #{@pay_date.strftime('%B %Y')}"
      return existing_payroll
    end
  
    gross_pay = calculate_gross_pay
    deductions = calculate_deductions(gross_pay)
    net_pay = gross_pay - deductions.values.sum
  
    payroll = Payroll.create!(
      employee_id: @employee.id,
      pay_date: @pay_date,
      gross_pay: gross_pay,
      net_pay: net_pay,
      tax_deductions: deductions[:tax],
      leave_deductions: deductions[:leave],
      other_deductions: deductions[:other]
    )
    @employee.update(excess_casual_leave: 0, excess_sick_leave: 0) if payroll.persisted?
    payroll
  rescue => e
    Rails.logger.error "Payroll generation failed: #{e.message}"
    raise
  end

  private

  def payroll_exists_for_month?
    Payroll.where(employee_id: @employee.id)
           .where('pay_date BETWEEN ? AND ?',
                 @pay_date.beginning_of_month,
                 @pay_date.end_of_month)
           .exists?
  end

  def find_existing_payroll
    Payroll.where(employee_id: @employee.id)
           .where('pay_date BETWEEN ? AND ?', 
                 @pay_date.beginning_of_month, 
                 @pay_date.end_of_month)
           .first
  end

  def calculate_gross_pay
    if @employee.salary.present?
      @employee.salary
    end
  end

  def calculate_hourly_pay
    hours_worked = calculate_hours_worked
    raise "Hourly rate not set for employee" unless @employee.hourly_rate.present?
    @employee.hourly_rate * hours_worked
  end

  def has_late_attendances?
    @employee.attendances
             .where(date: @pay_date.beginning_of_month..@pay_date.end_of_month)
             .where(status: 'late')
             .exists?
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
      leave: calculate_leave_deductions(gross_pay),
      other: has_late_attendances? ? calculate_late_deductions : 0
    }
  end

  def calculate_late_deductions
    late_attendances = @employee.attendances
                                .where(
                                  date: @pay_date.beginning_of_month..@pay_date.end_of_month,
                                  status: 'late'
                                )
    late_attendances.count * LATE_PENALTY_PER_DAY.to_f
  end

  def calculate_leave_deductions(gross_pay)
    daily_rate = gross_pay / 30.0
    
    deductions = 0
    
    if @employee.excess_casual_leave.to_i > 0
      deductions += daily_rate * @employee.excess_casual_leave
      Rails.logger.info "Deducting #{@employee.excess_casual_leave} casual leave days"
    end
    
    if @employee.excess_sick_leave.to_i > 0
      deductions += daily_rate * @employee.excess_sick_leave
    end
    
    deductions.round
  end
 
end