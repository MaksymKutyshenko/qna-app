Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: "questions#index"

  concern :votable do 
    patch :rate, on: :member
    delete :unrate, on: :member
  end

  get '/auth_confirmations', to: 'auth_confirmations#finish'
  get '/auth_confirmations/new', to: 'auth_confirmations#new'
  post '/auth_confirmations', to: 'auth_confirmations#create'

  resources :questions do
    resources :comments, shallow: true
    resources :answers, shallow: true do 
      resources :comments, shallow: true
      post :best, on: :member
      concerns :votable
    end
    concerns :votable
  end

  namespace :api do 
    namespace :v1 do 
      resources :profiles do 
        get :me, on: :collection
        get :index, on: :collection
      end
    end
  end

  resources :attachments, only: [:destroy]  

  mount ActionCable.server => '/cable'
end
