Rails.application.routes.draw do
  root 'groups#index'
  resources :groups do
    # ParticipantsController では adjust と update_adjustments のみを使用
    resources :participants, only: [:create, :destroy] do
      collection do
        get 'calculate'            # /groups/:group_id/participants/calculate
        patch 'save_calculations' # /groups/:group_id/participants/save_calculations
      end
    end
  end
end
