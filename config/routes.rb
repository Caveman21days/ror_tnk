Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers do
      member do
        patch 'set_the_best'
      end
    end
  end

  resources :attachments, only: [:destroy]

  root 'questions#index'
end
