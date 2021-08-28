Rails.application.routes.draw do
  devise_for :users

  resources :lists, only: %i(new create destroy)

  root 'lists#index'
end
