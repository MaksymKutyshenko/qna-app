Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: "questions#index"

  concern :votable do 
    patch :rate, on: :member
    delete :unrate, on: :member
  end

  resources :questions do
    resources :comments, shallow: true
    resources :answers, shallow: true do 
      resources :comments, shallow: true
      post :best, on: :member
      concerns :votable
    end
    concerns :votable
  end

  resources :attachments, only: [:destroy]  

  mount ActionCable.server => '/cable'
end
