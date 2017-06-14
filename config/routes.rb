Rails.application.routes.draw do
  resources :taryphs
  resources :prices
  resources :bookings
  
  resources :hotels, only: [:show, :index] do
  	resources :rooms, only: [:show, :index]
  end
  root 'hotels#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
