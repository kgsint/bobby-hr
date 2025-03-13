class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.time :default_start_time
      t.integer :late_grace_period_minutes
      t.string :code

      t.timestamps
    end
  end
end
