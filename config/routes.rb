Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beerclubs
  resources :users
  resources :beers
  
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'breweries#index'
  resources :ratings, only: [:index, :new, :create, :destroy]

  get 'signup', to: 'users#new'

  resource :session, only: [:new, :create, :destroy]
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  resources :places, only: [:index, :show]
  post 'places', to: 'places#search'

end
