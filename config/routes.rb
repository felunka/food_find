Rails.application.routes.draw do
  # For details on# the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'randomizer#get'
  post '/randomizer', to: 'randomizer#randomize'

  resources :foods
  resources :tags
  resources :registration_tokens, only: [:index, :create, :destroy]

  resource :session, only: [:new, :create, :destroy] do
    post :callback
  end

  resource :registration, only: [:new, :create] do
    post :callback
  end
end
