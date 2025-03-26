class Payroll < ApplicationRecord
  belongs_to :employee

  validates :employee_id, :pay_date, :gross_pay, :net_pay, presence: true
  validates :gross_pay, :net_pay, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_deductions, :benefits_deductions, :other_deductions, numericality: { greater_than_or_equal_to: 0 }
  validates :employee_id, uniqueness: { 
    scope: [:pay_date], 
    message: "already has a payroll for this month",
    conditions: -> { where("date_trunc('month', pay_date) = date_trunc('month', ?)", pay_date) }
  }
end
