Rails.application.routes.draw do
  root 'groups#index'
  get 'groups/share/:share_token', to: 'groups#share', as: 'share_group'
  resources :groups, only: [:index, :show, :create, :update, :destroy] do
    resources :participants, only: [:create, :update, :destroy], controller: 'groups/participants'
  end
end
