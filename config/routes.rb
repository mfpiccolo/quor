Rails.application.routes.draw do
  devise_for :users
  root :to => "visitors#index"

  resources :models do
    collection { get :model_types }
    collection { post :import }
    collection { get :search }
  end

  resources :users, only: [:edit, :update]
end
