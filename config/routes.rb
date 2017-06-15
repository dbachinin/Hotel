Rails.application.routes.draw do

  
  resources :bookings
  
  resources :hotels, only: [:show, :index] do
  	resources :rooms, only: [:show, :index] do
  		resources :prices do
         post 'create' => 'prices#create'
  			resources :taryphs
  		end
  	end
  end
  root 'hotels#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
