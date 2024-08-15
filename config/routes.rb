Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # for authentication
  get '/sign-up' => 'auth/register#new'
  post '/sing-up' => 'auth/register#create'

  get '/sign-in' => 'auth/session#new'
  post '/sign-in' => 'auth/session#create'
end
