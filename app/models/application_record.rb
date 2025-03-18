class ApplicationRecord < ActiveRecord::Base
  # primary_abstract_class
  self.abstract_class = true

  def self.inherited(subclass)
    super

    return unless subclass.superclass == self

    return unless subclass.column_names.include?('company_id')

    subclass.class_eval do
      include CompanyScoped
    end
  end
end
