# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(
  name: "Pyae Bhone",
  email: "pbz@gmail.com",
  phone_number: "1234567890",
  password_digest: BCrypt::Password.create("123"),
  company_id: 1,
  job_title: "Software Engineer",
  hire_at: Date.new(2022, 5, 10),
  department_id: 2,
  salary: 75000,
  hourly_rate: 35.50,
  role: "admin",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15)
)
