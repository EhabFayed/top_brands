Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :sections
    get "enums", to: "enums#index"

    post "signup", to: "authentication#signup"
    post "login", to: "authentication#login"

    resources :users
    resources :blogs do
      resources :blog_photos, only: [:create, :destroy] # Optional nested
    end
    resources :brands
    resource :company_data, only: [:show, :update] # Singleton resource
    resources :faqs
    resources :leaderships
    resources :products
  end
end
