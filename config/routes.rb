Rails.application.routes.draw do
  devise_for :users

  resources :lists, only: %i(new)

  root 'lists#index'
end
