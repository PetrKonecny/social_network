Rails.application.routes.draw do
  resources :images do
    resources :comments
    member do
      put 'like'
      put 'dislike'
    end
  end

  resources :albums
  resources :profiles do
    member do
      get 'friend'
      get 'unfriend'
      post 'friend_accept'
      post 'friend_decline'
    end
  end

  resource :chat, only: [:show]

  resources :conversations do
    resources :messages
  end

  resources :groups do
    member do
      put 'insert_user_to_group'
      put 'remove_user_from_group'
      put 'create_status'
      get 'show_members'
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

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root :to => 'statuses#index'
    end
    unauthenticated :user do
      root :to => 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
