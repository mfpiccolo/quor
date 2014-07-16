Rails.application.routes.draw do
  devise_for :users
  root :to => "visitors#index"

  resources :models, except: [:show]
  get       'models/:otype' => 'models#show'

  resources :users, only: [:edit, :update]
end
