Rails.application.routes.draw do
  devise_for :users
  root :to => "visitors#index"

  resources :models do
    collection { get :model_types }
    collection { get :search }
    collection { get :attributes }
  end

  resources :workflows

  resources :email_templates

  resources :imports, only: [:create]
  post :import_mappings, to: "imports#new"

  resources :model_states, only: [:new, :create] do
    collection { post :transition }
  end

  resources :model_mappings, only: [:index, :show]

  resources :users, only: [:edit, :update]
end
