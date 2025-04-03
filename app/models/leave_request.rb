class LeaveRequest < ApplicationRecord
  belongs_to :employee
  belongs_to :company

  after_update :deduct_leave_balance, if: :approved?

  validates :from, :to, :leave_type, presence: true
  validates :status, inclusion: { in: %w[pending approved declined] }, allow_nil: true
  validate :valid_date_range

  def approved?
    status == 'approved'
  end


  private

  def valid_date_range
    errors.add(:to, "must be after the start date") if from && to && from > to
  end


  def deduct_leave_balance
    days = (to - from).to_i + 1

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
    end
  end
end
