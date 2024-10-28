Rails.application.routes.draw do
  root to: 'chitoge/dashboard#index'

  # for authentication
  get 'register' => 'auth/register#new'
  post 'register' => 'auth/register#create'

  get 'login' => 'auth/session#new'
  post 'login' => 'auth/session#create'

  post 'logout' => 'auth/session#destroy'

  get 'forget-password' => 'auth/forget_password#new'
  post 'forget-password' => 'auth/forget_password#create'

  get 'reset-password/:token' => 'auth/password_reset#new'

  mount LetterOpenerWeb::Engine, at: "/letter_opener"


  namespace :chitoge do
    get "/dashboard" => "dashboard#index"
  end
end
