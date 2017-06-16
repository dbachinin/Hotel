Rails.application.routes.draw do

  
  
  resources :bookings
  resources :hotels, only: [:show, :index] do
  	resources :rooms, only: [:show, :index] do
  		resources :prices, shallow: true do
#         post 'create' => 'prices#create'

  			resources :taryphs
  		end
  	end
  end
  root 'hotels#index'
post "/prices/:id" => 'prices#update'
post "/taryphs/:id" => 'taryphs#update'
post "/bookings/new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
