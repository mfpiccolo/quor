Rails.application.routes.draw do
  devise_for :users
  root :to => "visitors#index"

  resources :models do
    collection { get :model_types }
    collection { post :import }
    collection { get :search }
  end

  resources :workflows

  resources :email_template_details

  resources :model_states, only: [] do
    collection { post :transition }
  end

  resources :users, only: [:edit, :update]
end
