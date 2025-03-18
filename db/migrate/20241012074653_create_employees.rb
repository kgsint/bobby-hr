class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.string :job_title
      t.date :date_of_birth
      t.integer :company_id
      t.date :hire_at
      t.integer :department_id
      t.integer :salary
      t.decimal :hourly_rate
      t.timestamps
    end
  end
end
