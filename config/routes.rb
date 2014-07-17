Rails.application.routes.draw do
  devise_for :users
  root :to => "visitors#index"

  resources :models do
    collection { post :import }
  end

  resources :users, only: [:edit, :update]
end
