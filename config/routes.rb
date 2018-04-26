Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  concern :votable do
    member do
      post :vote
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: [:create]
  end


  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: [:create, :destroy, :update] do
      member do
        patch 'set_the_best'
      end
    end
  end

  resources :attachments, only: [:destroy]


  mount ActionCable.server => '/cable'
end