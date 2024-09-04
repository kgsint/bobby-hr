Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :chitoge do
    get "/dashboard" => "dashboard#index"
  end
end
