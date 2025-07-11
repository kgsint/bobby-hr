class ChangeLeaveBalancesToFloat < ActiveRecord::Migration[7.1]
  def change
    change_column :employees, :casual_leave_balance, :float
    change_column :employees, :sick_leave_balance, :float
    change_column :employees, :annual_leave_balance, :float
    change_column :employees, :excess_casual_leave, :float
    change_column :employees, :excess_sick_leave, :float
    change_column :employees, :excess_annual_leave, :float
  end
end
