class LeaveRequest < ApplicationRecord
  belongs_to :employee
  belongs_to :company

  after_update :deduct_leave_balance, if: :approved?

  validates :from, :to, :leave_type, presence: true
  validates :status, inclusion: { in: %w[pending approved declined] }, allow_nil: true
  validate :valid_date_range
  validates :leave_duration, inclusion: { in: %w[full_day half_day], message: "%{value} is not a valid duration" }
  validate :half_day_must_be_single_day, if: -> { leave_duration == 'half_day' }

  def approved?
    status == 'approved'
  end


  def valid_date_range
    errors.add(:to, "must be after the start date") if from && to && from > to
  end


  def deduct_leave_balance
    days = leave_duration == 'half_day' ? 0.5 : (to - from).to_i + 1


    case leave_type
    when 'Casual'
      new_balance = employee.casual_leave_balance - days
      employee.update!(casual_leave_balance: new_balance)
      
      if new_balance.negative?
        employee.update!(excess_casual_leave: new_balance.abs)
      else
        employee.update!(excess_casual_leave: 0)
      end
    when 'Sick'
      new_balance = employee.sick_leave_balance - days
      employee.update!(sick_leave_balance: new_balance)

      if new_balance.negative?
        employee.update!(excess_sick_leave: new_balance.abs)
      else
        employee.update!(excess_sick_leave: 0)
      end
    when 'Annual'
      new_balance = employee.annual_leave_balance - days
      employee.update!(annual_leave_balance: new_balance)

      if new_balance.negative?
        employee.update!(excess_annual_leave: new_balance.abs)
      else
        employee.update!(excess_annual_leave: 0)
      end
    end

  end
  private

  def half_day_must_be_single_day
    errors.add(:leave_duration, "must be for a single day when half day") if from != to
  end

end
