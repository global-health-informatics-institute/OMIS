Rails.application.routes.draw do
  get 'main/home'
  resources :asset_categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  
  root "main#home"
end
