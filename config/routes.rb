require 'sidekiq/web'
Rails.application.routes.draw do
  resource :profile, only: [:show, :edit, :update]

  resources :messages do
    member do
      get 'audit_changes'
    end
  end
  # resources :posts
  devise_for :users,
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations',
               confirmations: 'confirmations',
               omniauth_callbacks: 'omniauth_callbacks',
               passwords: 'passwords'
             }
  mount Sidekiq::Web => '/sidekiq'
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        # post 'sign_in', to: 'sessions#create'
        # delete 'sign_out', to: 'sessions#destroy'
        # post 'sign_up', to: 'registrations#create'
        # get 'confirmation', to: 'confirmations#show'
      end
      resources :posts, only: [:index, :show, :create, :update, :destroy]
    end
  end
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users, only: [:index, :show, :new, :edit, :update, :create, :destroy] do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
      member do
        get 'audit_changes'
        # Define member-specific routes here
        patch :soft_delete
      end
    end
    post 'search', to: 'search#index', as: 'search'

    post 'search/suggestions', to: 'search#suggestions', as: 'search_suggestions'
    resources :posts
    resources :posts do
      member do
        get 'audit_changes'
      end
    end
  end
  resources :users
  root "users#index"
  resources :posts
end
