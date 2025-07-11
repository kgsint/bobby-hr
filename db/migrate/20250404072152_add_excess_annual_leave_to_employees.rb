class AddExcessAnnualLeaveToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :excess_annual_leave, :integer
  end
end
