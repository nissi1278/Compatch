Rails.application.routes.draw do
  root "static_pages#home"
  get 'groups/share/:share_token', to: 'groups#share', as: 'share_group'
  resources :groups, only: [:index, :show, :create, :update, :destroy] do
    resources :participants, only: [:create, :update, :destroy], controller: 'groups/participants'
  end

  match '*path', to: redirect('/'), via: :get
end
