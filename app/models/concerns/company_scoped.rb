module CompanyScoped
  extend ActiveSupport::Concern

  included do

    scope :with_current_company, -> {
      if Current.user.ghost_admin?
        all
      else
        where(company_id: Current.user&.company_id)
      end
    }

    before_validation :assign_current_company, on: :create
  end

  private

    def assign_current_company
      self.company_id ||= Current.user.company_id if Current.user && !Current.user.ghost_admin?
    end
end
