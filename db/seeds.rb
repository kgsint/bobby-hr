# super admins
User.create!(
  name: "Pyae Bhone",
  email: "pbz@gmail.com",
  phone_number: "1234567890",
  password_digest: BCrypt::Password.create("123"),
  role: "ghost_admin",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15),
)

User.create!(
  name: "Kaung Sint Ko Ko",
  email: "kgsint@mail.co.uk",
  phone_number: "00000",
  password_digest: BCrypt::Password.create("password"),
  role: "ghost_admin",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15),
)

# companies
bobby_hr = Company.create!(
  name: "Bobby HR",
  code: "10001",
  default_start_time: Time.zone.parse("9:00 AM"),
  late_grace_period_minutes: 10,
)

code2lab = Company.create!(
  name: "Code2Lab",
  code: "10002",
  default_start_time: Time.zone.parse("9:00 AM"),
  late_grace_period_minutes: 10,
)

# department
bobby_hr_it_department = Department.create!(
  name: "IT Department",
  company_id: bobby_hr.id,
)

bobby_hr_hr_department = Department.create!(
  name: "HR Department",
  company_id: bobby_hr.id,
)

code2lab_sales_department = Department.create!(
  name: "Sales Department",
  company_id: code2lab.id,
)

code2lab_it_department = Department.create!(
  name: "IT Department",
  company_id: code2lab.id,
)

code2lab_hr_department = Department.create!(
  name: "HR Department",
  company_id: code2lab.id,
)

# company admin
Employee.create!(
  name: "Sussy",
  email: "sussy@bobbyhr.com",
  phone_number: "1234567890",
  company_id: bobby_hr.id,
  department_id: bobby_hr_hr_department.id,
  hire_at: Time.current,
  job_title: "HR Manager",
  salary: 100000,
  hourly_rate: 1389,
)

User.create!(
  name: "Sussy",
  email: "sussy@bobbyhr.com",
  phone_number: "0987654321",
  password_digest: BCrypt::Password.create("password"),
  role: "company_admin",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15),
  company_id: bobby_hr.id,
)

Employee.create!(
  name: "Amy",
  email: "amy@code2lab.com",
  phone_number: "1234567890",
  company_id: code2lab.id,
  department_id: code2lab_hr_department.id,
  hire_at: Time.current,
  job_title: "HR Manager",
  salary: 100000,
  hourly_rate: 1389,
)

User.create!(
  name: "Amy",
  email: "amy@code2lab.com",
  phone_number: "0987654321",
  password_digest: BCrypt::Password.create("password"),
  role: "company_admin",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15),
  company_id: code2lab.id,
)

# employees
User.create!(
  name: "John Doe",
  email: "johndoe@bobbyhr.com",
  phone_number: "1234567890",
  password_digest: BCrypt::Password.create("password"),
  role: "employee",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15),
  company_id: bobby_hr.id,
)

Employee.create!(
  name: "John Doe",
  email: "johndoe@bobbyhr.com",
  phone_number: "1234567890",
  company_id: bobby_hr.id,
  department_id: bobby_hr_it_department.id,
  hire_at: Time.current,
  job_title: "Software Engineer",
)

User.create!(
  name: "Jane Doe",
  email: "janedoe@bobbyhr.com",
  phone_number: "0987654321",
  password_digest: BCrypt::Password.create("password"),
  role: "employee",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15),
  company_id: bobby_hr.id,
)

Employee.create!(
  name: "Jane Doe",
  email: "janedoe@bobbyhr.com",
  phone_number: "0987654321",
  company_id: bobby_hr.id,
  department_id: bobby_hr_it_department.id,
  hire_at: Time.current,
  job_title: "Software Tester",
)

User.create!(
  name: "Sam",
  email: "sam@code2lab.com",
  phone_number: "0987654321",
  password_digest: BCrypt::Password.create("password"),
  role: "employee",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15),
  company_id: code2lab.id,
)

Employee.create!(
  name: "Sam",
  email: "sam@code2lab.com",
  phone_number: "0987654321",
  company_id: code2lab.id,
  department_id: code2lab_it_department.id,
  hire_at: Time.current,
  job_title: "Software Engineer",
)

User.create!(
  name: "Smith",
  email: "smith@code2lab.com",
  phone_number: "0987654321",
  password_digest: BCrypt::Password.create("password"),
  role: "employee",
  last_login_at: Time.current,
  date_of_birth: Date.new(1995, 3, 15),
  company_id: code2lab.id,
)

Employee.create!(
  name: "Smith",
  email: "smith@code2lab.com",
  phone_number: "0987654321",
  company_id: code2lab.id,
  department_id: code2lab_sales_department.id,
  hire_at: Time.current,
  job_title: "Sales Manager",
)
