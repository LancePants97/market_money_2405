Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "/api/v0/markets/search", to: "api/v0/markets#search"
  get "/api/v0/markets/:id/nearest_atms", to: "api/v0/markets#nearest_atms"

  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index], controller: :market_vendors
      end
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only:[:create, :destroy]
    end
  end


end
