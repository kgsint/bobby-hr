Rails.application.routes.draw do
  get '/' => 'home#show', as: 'profile'

  root to: 'chitoge/dashboard#index'

  mount LetterOpenerWeb::Engine, at: "/letter_opener"


  # for authentication
  get 'register' => 'auth/register#new'
  post 'register' => 'auth/register#create'

  get 'login' => 'auth/session#new'
  post 'login' => 'auth/session#create'

  post 'logout' => 'auth/session#destroy'

  get 'forget-password' => 'auth/forget_password#new'
  post 'forget-password' => 'auth/forget_password#create'

  resources :employees

  namespace :chitoge do
    # authentication
    namespace :auth do
      get 'login' => 'session#new'
      post 'login' => 'session#create'

      post 'logout' => 'session#destroy'
    end

    resources :employees do
      resources :payrolls, only: [:index, :new, :create]
      resources :attendances, only: [:index, :create] do
        collection do
          post 'check_in', to: 'attendances#check_in'
          post 'check_out', to: 'attendances#check_out'
        end
      end
    end

    resources :attendances, only: [:index]
    resources :departments
    resources :companies do
      get "departments", to: "companies#departments"
    end
    get 'employees/index'

    get "/dashboard" => "dashboard#index"

  end
end
