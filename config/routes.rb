Rails.application.routes.draw do

  # get 'user_sessions/new'
  # get 'user_sessions/create'
  resources :users #, only: [:index, show]
  resources :projects
  resources :branches
  resources :employees
  resources :timesheets
  #resources :requisitions
  resources :leave_requests
  resources :inventory_items
  resources :inventory_item_categories
  resources :inventory_item_thresholds
  resources :inventory_item_types
  resources :project_tasks
  resources :business_assets
  resources :time_sheet_tasks
  resources :project_task_assignments
  resources :user_sessions, only: [:new, :create, :destroy]

  put 'timesheets/:id/submit_timesheet', to: 'timesheets#submit_timesheet'
  put 'timesheets/:id/approve_timesheet', to: 'timesheets#approve_timesheet'
  put 'timesheets/:id/reject_timesheet', to: 'timesheets#reject_timesheet', as: :reject_timesheet
  put 'timesheets/:id/recall_timesheet', to: 'timesheets#recall_timesheet'
  put 'timesheets/:id/re-open_timesheet', to: 'timesheets#reopen_timesheet'
  put 'timesheets/:id/re-submit_timesheet', to: 'timesheets#resubmit_timesheet'
  get 'my_timesheet', to: 'timesheets#show', as: :my_timesheet

  get 'settings/index'
  get 'settings/new'
  post 'settings/create'
  get 'settings/edit'

  get 'requisitions', to: 'requisitions#index'
  get 'requisitions/new', to: 'requisitions#new', defaults: { format: :turbo_stream }
  post 'requisitions/create'
  get 'requisitions/:id', to: 'requisitions#show'
  get 'requisitions/edit'
  patch 'requisitions/:id', to: 'requisitions#resubmit_request', as: :resubmit_request_requisition
  post '/clear_flash', to: 'application#clear_flash', as: :clear_flash

  put 'requisitions/:id/approve_request', to: 'requisitions#approve_request'
  put 'requisitions/:id/re-submit_request', to: 'requisitions#resubmit_request'
  put 'requisitions/:id/approve_funds', to: 'requisitions#approve_funds'
  put 'requisitions/:id/deny_funds', to: 'requisitions#deny_funds'
  put 'requisitions/:id/release_funds', to: 'requisitions#release_funds'
  put 'requisitions/:id/rescind_request', to: 'requisitions#rescind_request'
  put 'requisitions/:id/reject_request', to: 'requisitions#reject_request'
  put 'requisitions/:id/recall_request', to: 'requisitions#recall_request'
  put 'requisitions/:id/collect_funds', to: 'requisitions#collect_funds'

  put 'leave_requests/:id/approve_leave', to: 'leave_requests#approve_leave'
  put 'leave_requests/:id/cancel_leave', to: 'leave_requests#cancel_leave'
  put 'leave_requests/:id/deny_leave', to: 'leave_requests#deny_leave'
  put 'leave_requests/:id/rescind_request', to: 'leave_requests#rescind_request'

  get 'reports/index'
  get 'reports/new'
  get 'reports/create'
  get 'reports/edit'
  get 'reports/monthly_org_loe_report'

  get 'users/index'
  get 'forgot_password', to: 'users#forgot_password'
  post 'password_reset_forget', to: 'users#password_reset_forget'
  put 'users/:id/password_reset', to: 'users#password_reset'
  get 'main/home'
  get 'about', to: 'main#about'

  get "generate_report", to: 'reports#show', as: "generate_report", defaults: { format: :turbo_stream }

  get "logout", to: "user_sessions#destroy"
  resources :asset_categories

  get 'tc_dashboard/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "main#home"
end
