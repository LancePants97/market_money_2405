Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "/api/v0/markets/search", to: "api/v0/markets#search"

  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index], controller: :market_vendors
      end
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only:[:create]
      delete 'market_vendors', to: 'market_vendors#destroy' #was unsure how to get this without the /:id
    end
  end


end
