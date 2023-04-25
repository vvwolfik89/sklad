Rails.application.routes.draw do
  devise_for :users, skip: "registration"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :departments
  resources :users
  # Defines the root path route ("/")
  root "departments#index"
end
