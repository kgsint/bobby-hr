class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.string :password_digest, null: false
      t.integer :company_id
      t.string :job_title
      t.date :hire_at
      t.integer :department_id
      t.integer :salary, precision: 10, scale: 2
      t.decimal :hourly_rate
      t.string :role, default: 'employee'
      t.timestamp :last_login_at
      t.datetime :date_of_birth

      t.timestamps
    end
  end
end
