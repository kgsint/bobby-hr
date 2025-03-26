class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :company
  has_many :attendances, dependent: :destroy
  has_many :leave_requests
  has_many :payrolls

  def attendance_by_date(date)
    attendances.where(checkin_time: date.beginning_of_day..date.end_of_day).first
  end

  def attendances_for_date_range(from, to)
    attendances.where(checkin_time: from.beginning_of_day..to.end_of_day)
  end

end
