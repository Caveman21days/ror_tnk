Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :vote
    end
  end


  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable do
      member do
        patch 'set_the_best'
      end
    end
  end

  resources :attachments, only: [:destroy]

  root 'questions#index'

  mount ActionCable.server => '/cable'
end