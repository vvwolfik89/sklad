Rails.application.routes.draw do
  devise_for :users, skip: "registration"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :departments
  resources :users
  resources :roles
  resources :permissions
  resources :cars
  namespace :registers do
    resources :car_inspections, except: :show
  end

  resources :partners do
    collection { post :import }
  end
  # Defines the root path route ("/")
  root "departments#index"
end
