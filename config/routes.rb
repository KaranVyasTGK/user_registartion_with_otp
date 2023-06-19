Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # registrations

  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"

  get 'otp_page' => "users#otp_page"
  post 'verify_otp' => "users#verify_otp"
  post 'update_2fa' => "users#update_2fa"
end
