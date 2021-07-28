Rails.application.routes.draw do
  # For details on# the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'randomizer#get'

  resources :foods
  resources :tags

  post '/randomizer', to: 'randomizer#randomize'

  resource :session, only: [:new, :create, :destroy] do
    post :callback
  end

  resource :registration, only: [:new, :create] do
    post :callback
  end
end
