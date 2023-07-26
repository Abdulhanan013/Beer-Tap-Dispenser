Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  resources :users, only: [:create, :show, :update, :destroy]
  resources :dispensers, only: [:create, :update, :index]
end
