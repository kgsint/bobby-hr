class AddLeaveBalancesToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :casual_leave_balance, :integer, default: 12, null: false
    add_column :employees, :sick_leave_balance, :integer, default: 10, null: false
    add_column :employees, :annual_leave_balance, :integer, default: 15, null: false
  end
end
