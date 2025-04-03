class Attendance < ApplicationRecord
  belongs_to :employee
  belongs_to :company

  validates :date, presence: true
  validates :employee_id, presence: true

  after_create :determine_status

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

  # def determine_status
  #   company = self.company
  #   default_start_time = company.default_start_time
  #   grace_period_minutes = company.late_grace_period_minutes

  #   return "present" unless default_start_time # Default to present if no start time set

  #   scheduled_start_datetime = self.date.to_datetime.change(hour: default_start_time.hour, min: default_start_time.min, sec: default_start_time.sec)
  #   late_threshold_datetime = scheduled_start_datetime + grace_period_minutes.minutes

  #   # byebug
  #   if checkin_time.present? && checkin_time <= late_threshold_datetime
  #     self.status = "on_time"
  #   elsif checkin_time.present? && checkin_time > late_threshold_datetime
  #     self.status = "late"
  #   end

  #   self.save!
  # end

  def determine_status
    company = self.company
    default_start_time = company.default_start_time
    grace_period_minutes = company.late_grace_period_minutes
  
    return "present" unless default_start_time
  
    scheduled_start = self.date.in_time_zone("Asia/Yangon").change(
      hour: default_start_time.hour,
      min: default_start_time.min,
      sec: default_start_time.sec
    )
  
    late_threshold = scheduled_start + grace_period_minutes.minutes
  
    if checkin_time <= late_threshold
      self.status = "on_time"
    else
      self.status = "late"
    end

    self.save
  end
end
