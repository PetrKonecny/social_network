Rails.application.routes.draw do
  resources :profiles
  resources :comments do
    member do
      put 'like'
      put 'dislike'
    end
  end
  resources :statuses do
    resources :comments
    member do
      put 'like'
      put 'dislike'
    end
  end
  root to: 'statuses#index'
  devise_for :users
end
