class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.string :job_title
      t.integer :company_id
      t.date :hire_at
      t.integer :department_id
      t.integer :salary, precision: 10, scale: 2
      t.decimal :hourly_rate
      t.timestamps
    end
  end
end
