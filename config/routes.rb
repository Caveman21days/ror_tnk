Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root 'questions#index'
  get 'confirmation' => 'confirmation#confirmation'
  post 'send_confirmation_of_email' => 'confirmation#send_confirmation_of_email'


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

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end