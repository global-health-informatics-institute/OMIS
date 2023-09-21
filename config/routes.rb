Rails.application.routes.draw do

  # get 'user_sessions/new'
  # get 'user_sessions/create'
  resources :users, only: [:index]
  resources :projects
  resources :branches
  resources :employees
  resources :timesheets
  resources :project_tasks
  resources :business_assets
  resources :time_sheet_tasks
  resources :project_task_assignments
  resources :user_sessions, only: [:new, :create, :destroy]

  get 'settings/index'
  get 'settings/new'
  get 'settings/create'
  get 'settings/edit'

  get 'requisitions/index'
  get 'requisitions/new'
  get 'requisitions/create'
  get 'requisitions/edit'

  get 'reports/index'
  get 'reports/new'
  get 'reports/create'
  get 'reports/edit'
  get 'users/index'
  get 'main/home'

  get "logout", to: "user_sessions#destroy"
  resources :asset_categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  
  root "main#home"
end
