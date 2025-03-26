class CreatePayrolls < ActiveRecord::Migration[7.1]
  def change
    create_table :payrolls do |t|
      t.bigint :employee_id, null: false
      t.date :pay_date, null: false
      t.integer :gross_pay, null: false
      t.integer :net_pay, null: false
      t.integer :tax_deductions, default: 0
      t.integer :benefits_deductions, default: 0
      t.integer :other_deductions, default: 0

      t.timestamps
    end
  end
end
