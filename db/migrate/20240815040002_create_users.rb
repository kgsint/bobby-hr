class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.integer :company_id
      t.string :role, default: 'employee'
      t.timestamp :last_login_at

      t.timestamps
    end
  end
end
