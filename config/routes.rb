Rails.application.routes.draw do
  # Existing resources and routes
  resources :users
  resources :projects
  resources :branches
  resources :employees
  resources :timesheets
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

  # Travel Requests
  get 'travel_requests/new', to: 'travel_requests#new', as: :save_budget_details
  post 'travel_requests/create', to: 'travel_requests#create', as: :create_travel_requests
  get 'travel_requests/:id', to: 'travel_requests#show', as: :travel_request_show

  # Timesheets
  put 'timesheets/:id/submit_timesheet', to: 'timesheets#submit_timesheet'
  put 'timesheets/:id/approve_timesheet', to: 'timesheets#approve_timesheet'
  put 'timesheets/:id/reject_timesheet', to: 'timesheets#reject_timesheet', as: :reject_timesheet
  put 'timesheets/:id/recall_timesheet', to: 'timesheets#recall_timesheet'
  put 'timesheets/:id/re-open_timesheet', to: 'timesheets#reopen_timesheet'
  put 'timesheets/:id/re-submit_timesheet', to: 'timesheets#resubmit_timesheet'
  get 'my_timesheet', to: 'timesheets#show', as: :my_timesheet

  # Settings
  get 'settings/index'
  get 'settings/new'
  post 'settings/create'
  get 'settings/edit'

  # Purchase Requests
  post 'purchase_requests/create', to: 'purchase_requests#create', as: :create_purchase_request
  get 'purchase_requests/new', to: 'purchase_requests#new', as: :new_purchase_request
  get 'purchase_request/show', to: 'purchase_request#show'
  put 'purchase_requests/:id/approve_request', to: 'purchase_requests#approve_request'
  put 'purchase_requests/:id/reject_request', to: 'purchase_requests#reject_request'
  put 'purchase_requests/:id/source_quotations', to: 'purchase_requests#source_quotations'
  patch 'purchase_requests/:id/toggle_ipc', to: 'purchase_requests#toggle_ipc', as: :toggle_ipc_purchase_request
  match 'purchase_requests/:id/request_payment', to: 'purchase_requests#request_payment', via: [:patch, :put], as: :complete_procurement_purchase_request
  put 'purchase_requests/:id/require_ipc', to: 'purchase_requests#require_ipc'
  put 'purchase_requests/:id/approve_funds', to: 'purchase_requests#approve_funds'
  put 'purchase_requests/:id/deny_funds', to: 'purchase_requests#deny_funds'

  # Requisitions - Modified to include amount endpoint
  resources :requisitions, except: [:index, :new, :create, :show, :edit] do
    member do
      get :amount  # This adds /requisitions/:id/amount endpoint
    end
  end
  
  get 'requisitions', to: 'requisitions#index'
  get 'requisitions/new', to: 'requisitions#new', defaults: { format: :turbo_stream }
  post 'requisitions/create'
  get 'requisitions/:id', to: 'requisitions#show'
  get 'requisitions/edit'
  patch 'requisitions/:id', to: 'requisitions#resubmit_request', as: :resubmit_request_requisition
  put 'requisitions/:id/approve_request', to: 'requisitions#approve_request'
  put 'requisitions/:id/re-submit_request', to: 'requisitions#resubmit_request'
  put 'requisitions/:id/approve_funds', to: 'requisitions#approve_funds'
  put 'requisitions/:id/deny_funds', to: 'requisitions#deny_funds'
  put 'requisitions/:id/release_funds', to: 'requisitions#release_funds'
  put 'requisitions/:id/rescind_request', to: 'requisitions#rescind_request'
  put 'requisitions/:id/reject_request', to: 'requisitions#reject_request'
  put 'requisitions/:id/recall_request', to: 'requisitions#recall_request'
  put 'requisitions/:id/collect_funds', to: 'requisitions#collect_funds'
  put 'requisitions/:id/disburse_funds', to: 'requisitions#disburse_funds'
  patch 'requisitions/:id/liquidate_funds', to: 'requisitions#liquidate_funds', as: :liquidate_funds_requisition

  # Leave Requests
  put 'leave_requests/:id/approve_leave', to: 'leave_requests#approve_leave'
  put 'leave_requests/:id/cancel_leave', to: 'leave_requests#cancel_leave'
  put 'leave_requests/:id/deny_leave', to: 'leave_requests#deny_leave'
  put 'leave_requests/:id/rescind_request', to: 'leave_requests#rescind_request'

  # Reports
  get 'reports/index'
  get 'reports/new'
  get 'reports/create'
  get 'reports/edit'
  get 'reports/monthly_org_loe_report'

  # Users
  get 'users/index'
  get 'forgot_password', to: 'users#forgot_password'
  post 'password_reset_forget', to: 'users#password_reset_forget'
  put 'users/:id/password_reset', to: 'users#password_reset'
  
  # Main
  get 'main/home'
  get 'about', to: 'main#about'

  # Reports
  get "generate_report", to: 'reports#show', as: "generate_report", defaults: { format: :turbo_stream }

  # Authentication
  get "logout", to: "user_sessions#destroy"
  resources :asset_categories

  # Dashboard
  get 'tc_dashboard/index'

  # Flash messages
  post '/clear_flash', to: 'application#clear_flash', as: :clear_flash

  # Root
  root "main#home"
end