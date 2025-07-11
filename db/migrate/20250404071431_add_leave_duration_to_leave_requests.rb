class AddLeaveDurationToLeaveRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :leave_requests, :leave_duration, :string
  end
end
