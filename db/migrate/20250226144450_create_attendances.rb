class CreateAttendances < ActiveRecord::Migration[7.1]
  def change
    create_table :attendances do |t|
      t.integer :employee_id
      t.date :date
      t.datetime :checkin_time
      t.datetime :checkout_time
      t.decimal :hours_worked
      t.decimal :overtime
      t.string :status

      t.timestamps
    end
  end
end