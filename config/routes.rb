Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  resources :users, only: [:create, :show, :update, :destroy]
  resources :dispensers do
    collection do
      get 'total_statistics', to: 'dispensers#total_statistics'
    end
  end
end
