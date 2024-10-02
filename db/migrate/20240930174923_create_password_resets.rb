class CreatePasswordResets < ActiveRecord::Migration[7.1]
  def change
    create_table :password_resets do |t|
      t.string :email
      t.string :token
      t.timestamp :created_at

    end
  end
end
