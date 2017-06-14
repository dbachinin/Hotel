Rails.application.routes.draw do
  resources :taryphs
  resources :prices
  resources :bookings
  resources :rooms
  resources :hotels
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
