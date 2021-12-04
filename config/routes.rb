Rails.application.routes.draw do
  get 'map' => "establishments#map"
  resources :establishments
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: 'pages#home'
  get 'pages/search', to: 'pages#search'
  post 'fetch_position', to: 'establishments#fetch_position'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
