Rails.application.routes.draw do
  devise_for :users
  root :to => "visitors#index"

  resources :models

  resources :users, only: [:edit, :update]
end
