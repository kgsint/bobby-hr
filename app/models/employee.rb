class Employee < ApplicationRecord
  has_secure_password

  self.table_name = 'users'
  belongs_to :department
  belongs_to :company
  has_many :attendances, dependent: :destroy

  default_scope { where(role: 'employee') }
end
