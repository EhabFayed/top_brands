Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :sections
    get "enums", to: "enums#index"
    get "enums/get_all_counts", to: "enums#get_all_counts"
    post "signup", to: "authentication#signup"
    post "login", to: "authentication#login"
    get "web_site/get_page", to: "web_site#get_page"
    get "web_site/show_brand_products/:id", to: "web_site#show_brand_products"
    get "web_site/get_all_faqs", to: "web_site#get_all_faqs"
    get "web_site/show_faq/:id", to: "web_site#show_faq"
    get "web_site/show_blog/:id", to: "web_site#show_blog"
    get "web_site/get_all_blogs", to: "web_site#get_all_blogs"

    resources :users
    resources :blogs
    resources :blog_contents
    resources :brands
    resource :company_data, only: [:show, :update] # Singleton resource
    resources :faqs
    resources :products
  end
end
