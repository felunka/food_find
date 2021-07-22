Rails.application.routes.draw do
  # For details on# the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'randomizer#get'

  resources :foods
  resources :tags

  post '/randomizer', to: 'randomizer#randomize'
end
