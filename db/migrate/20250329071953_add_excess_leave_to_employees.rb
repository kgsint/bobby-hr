class AddExcessLeaveToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :excess_casual_leave, :integer
    add_column :employees, :excess_sick_leave, :integer
  end
end
