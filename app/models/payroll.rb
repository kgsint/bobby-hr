class Payroll < ApplicationRecord
  belongs_to :employee

  validates :employee_id, :pay_date, :gross_pay, :net_pay, presence: true
  validates :gross_pay, :net_pay, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_deductions, :leave_deductions, :other_deductions, numericality: { greater_than_or_equal_to: 0 }
  
end
