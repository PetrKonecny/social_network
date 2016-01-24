Rails.application.routes.draw do
  resources :profiles do
    member do
      get 'friend'
      post 'friend_accept'
      post 'friend_decline'
    end
  end

  # post 'profiles/accept'       ## foo is the name of your controller
  # post 'profiles/decline'
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
