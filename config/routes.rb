Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do 
    patch :rate, on: :member
    delete :unrate, on: :member
  end

  resources :questions do
    resources :answers, shallow: true do 
      post :best, on: :member
      concerns :votable
    end
    concerns :votable
  end

  resources :attachments, only: [:destroy]  
end
