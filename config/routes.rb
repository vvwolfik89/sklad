Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :departments
  # Defines the root path route ("/")
  root "departments#index"
end
