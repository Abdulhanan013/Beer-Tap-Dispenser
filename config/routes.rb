Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  resources :users, only: [:create, :show, :update, :destroy]
  resources :dispensers do
    resources :dispenser_events, only: [:create, :update]
  end
end
