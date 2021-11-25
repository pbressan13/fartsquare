Rails.application.routes.draw do
  resources :establishments
  devise_for :users
  root to: 'pages#home'
  get 'pages/search', to: 'pages#search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
