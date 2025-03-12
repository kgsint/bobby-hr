class Attendance < ApplicationRecord
  belongs_to :employee

  validates :date, presence: true
  validates :employee_id, presence: true

  # Ensure check-out happens only after check-in
  validate :checkout_after_checkin, if: -> { checkin_time.present? && checkout_time.present? }

  def checkout_after_checkin
    if checkout_time < checkin_time
      errors.add(:checkout_time, "must be after check-in time")
    end
  end

  # Calculates hours worked
  def hours_worked
    return 0 unless checkin_time && checkout_time
    ((checkout_time - checkin_time) / 1.hour).round(2)
  end

end
