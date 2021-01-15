Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    get "static_pages/help"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users
    resources :account_activations, only: %i(edit)
    get "/login", to: "session#new"
    post "/login", to: "session#create"
    delete "logout", to: "session#destroy"
  end
end
