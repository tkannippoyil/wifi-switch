InterfaceApi::Application.routes.draw do
  root to: 'high_voltage/pages#show', id: 'index'

  # Use our own controllers and routes instead of Devise's (see devise_scope block).
  devise_for :users, skip: :all

  # API (@TODO: Probably explicit API since the API will have its own subdomain)
  namespace :api, defaults: {format: 'json'} do
    # Version 1
    namespace :v1 do
      devise_scope :user do
        post    :auth,      to: 'auth#create'
        delete  :auth,      to: 'auth#destroy'
        post    :passwords, to: 'passwords#create'
        put     :passwords, to: 'passwords#update'
      end

      get 'users/exists', to: 'users#exists'

      resources :users, only: [:index, :show] do
        get  :profile, to: 'profiles#show'
        put  :profile, to: 'profiles#update'
      end

      resources :profiles, only: :show

      put 'users/change_password', to: 'users#change_password'

      resources :notifications, only: :index

      resources :devices do
        member do
          get :turn_on
          get :turn_off
          get :restart
          get :status
        end

        collection do
          get :turn_on_all
          get :turn_off_all
          get :toggle_all
        end
      end
      resources :schedules

      resources :mobile_devices, only: [ :create, :destroy ]

      get :ping, to: 'ping#index'
    end
  end

  mount Resque::Server, at: '/resque'
end
