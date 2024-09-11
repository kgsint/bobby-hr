Rails.application.routes.draw do
  root to: 'dashboard#index'

  # for authentication
  get 'register' => 'auth/register#new'
  post 'register' => 'auth/register#create'

  get 'login' => 'auth/session#new'
  post 'login' => 'auth/session#create'

  post 'logout' => 'auth/session#destroy'

  get 'forget-password' => 'auth/forget_password#new'
  post 'forget-password' => 'auth/forget_password#create'
end
