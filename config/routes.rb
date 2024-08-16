Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # for authentication
  get '/register' => 'auth/register#new'
  post '/register' => 'auth/register#create'

  get '/log-in' => 'auth/session#new'
  post '/log-in' => 'auth/session#create'
end
