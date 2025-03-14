# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_13_135354) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.integer "employee_id"
    t.date "date"
    t.datetime "checkin_time"
    t.datetime "checkout_time"
    t.decimal "hours_worked"
    t.decimal "overtime"
    t.string "status"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.time "default_start_time"
    t.integer "late_grace_period_minutes"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.string "job_title"
    t.date "date_of_birth"
    t.integer "company_id"
    t.date "hire_at"
    t.integer "department_id"
    t.integer "salary"
    t.decimal "hourly_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_requests", force: :cascade do |t|
    t.bigint "employee_id"
    t.date "from"
    t.date "to"
    t.string "leave_type"
    t.string "status", default: "pending"
    t.date "approved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payrolls", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.date "pay_date", null: false
    t.integer "gross_pay", null: false
    t.integer "net_pay", null: false
    t.integer "tax_deductions", default: 0
    t.integer "benefits_deductions", default: 0
    t.integer "other_deductions", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.string "password_digest", null: false
    t.integer "company_id"
    t.string "role", default: "employee"
    t.datetime "last_login_at", precision: nil
    t.datetime "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
