class Company < ApplicationRecord
  has_many :employees
  has_many :departments
  has_many :attendances

  # attribute :default_start_time, :time, default: Time.zone.parse("11:00 PM")
  # attribute :late_grace_period_minutes, :integer, default: 10
end
