Rails.application.routes.draw do
  # Devise routes for users and admin users
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root path
  root "home#index"

  # RESTful routes
  resources :households
  resources :transactions
  resources :banks

  # Static page route
  get 'home/index'
end
