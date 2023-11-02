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

  put 'timesheets/:id/submit_timesheet', to: 'timesheets#submit_timesheet'
  put 'timesheets/:id/approve_timesheet', to: 'timesheets#approve_timesheet'
  put 'timesheets/:id/reject_timesheet', to: 'timesheets#recall_timesheet'
  put 'timesheets/:id/recall_timesheet', to: 'timesheets#recall_timesheet'

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
  get 'users/:id/password_reset', to: 'users#password_reset'
  put 'users/:id/password_reset', to: 'users#password_reset'
  get 'main/home'
  get 'about', to: 'main#about'

  get "logout", to: "user_sessions#destroy"
  resources :asset_categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  
  root "main#home"
end
