class LeaveRequest < ApplicationRecord
  belongs_to :employee, class_name: "User"

  validates :from, :to, :leave_type, presence: true
  validates :status, inclusion: { in: %w[pending approved declined] }, allow_nil: true
  validate :valid_date_range

  private

  def valid_date_range
    errors.add(:to, "must be after the start date") if from && to && from > to
  end
end
