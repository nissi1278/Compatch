Rails.application.routes.draw do
  root 'groups#index'
  resources :groups do
      member do
        get 'calculate'
        patch 'calculate'
        patch 'save_calculations'
      end
    resources :participants, only: [:create, :update, :destroy]
  end
end
