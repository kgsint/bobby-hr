json.extract! payroll, :id, :employee_id, :pay_date, :gross_pay, :net_pay, :tax_deductions, :benefits_deductions, :other_deductions, :created_at, :updated_at
json.url payroll_url(payroll, format: :json)
