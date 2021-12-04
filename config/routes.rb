require "sidekiq/web"

Rails.application.routes.draw do
  get 'map' => "establishments#map"
  resources :establishments
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: 'pages#home'
  get 'pages/search', to: 'pages#search'
  post 'fetch_position', to: 'pages#fetch_position'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Sidekiq Web UI, only for admins.
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
