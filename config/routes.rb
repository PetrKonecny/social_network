Rails.application.routes.draw do
  resources :profiles
  resources :statuses do
    member do
      put 'like'
      put 'dislike'
    end
  end
  root to: 'statuses#index'
  devise_for :users
end
