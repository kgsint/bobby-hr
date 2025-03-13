class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  def ghost_admin?
    self.role == 'ghost_admin'
  end

  def company_admin?
    self.role == 'company_admin'
  end

  def employee?
    self.role == 'employee'
  end
end
