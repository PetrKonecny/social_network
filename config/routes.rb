Rails.application.routes.draw do
  resources :profiles do
    member do
      get 'friend'
      get 'unfriend'
      post 'friend_accept'
      post 'friend_decline'
    end
  end

  resources :profiles do
    resources :groups do
      member do 
        put 'insert_user_to_group'
        put 'remove_user'
      end
    end
  end

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
