Rails.application.routes.draw do
  get 'comments/create'
  devise_for :users

  resources :lists, only: %i(new create destroy) do
    resources :tasks, only: :show do
      resources :comments, only: :create
    end
  end

  root 'lists#index'
end
