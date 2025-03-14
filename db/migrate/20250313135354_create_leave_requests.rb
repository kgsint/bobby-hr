class CreateLeaveRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :leave_requests do |t|
      t.bigint :employee_id
      t.date :from
      t.date :to
      t.string :leave_type
      t.string :status, default: "pending"
      t.date :approved_at

      t.timestamps
    end
  end
end
