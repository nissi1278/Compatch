Rails.application.routes.draw do
  root 'groups#index'
  resources :groups, only: [:index, :show, :create, :update, :destroy] do
    resources :participants, only: [:create, :update, :destroy], controller: 'groups/participants'
  end
end
