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
  resources :product_types

  resources :order_logs do
    member do
      get :version_history  # ← внутри блока resources!
    end
  end
  resources :journals do
    resources :fields, only: [:create, :update, :destroy], module: :journals
    resources :entries, module: :journals  do
      member do
        get :version_history  # ← внутри блока resources!
      end
    end# ← эта строка
    resource :schedule, only: [:edit, :update], module: :journals
    member do
      get :version_history  # ← внутри блока resources!
    end
  end

  # Дополнительные маршруты для удобства
  # get "/journals/:journal_id/schedule/edit", to: "journals/schedules#edit", as: :edit_journal_schedule
  # patch "/journals/:journal_id/schedule", to: "journals/schedules#update", as: :update_journal_schedule


  # Defines the root path route ("/")
  root "order_logs#index"
end
