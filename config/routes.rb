Rails.application.routes.draw do
  root "restaurants#index"

  resources :restaurants, only: [:index, :show]
  resources :cuisines, only: [:index, :show]
  resources :meals, only: [:index, :show]

  get "about", to: "pages#about"
end