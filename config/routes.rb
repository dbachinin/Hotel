Rails.application.routes.draw do

  
  
  
  get 'persons/getall'

  devise_for :users
  resources :bookings do
  	collection do
  		get 'download_pdf'
  	end
  end
  resources :services
  
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
post "/subprice" => 'bookings#subprice'
get  "/subprice" => 'bookings#subprice'
get "/persons" => 'persons#getall'
get "/persons/show" => 'persons#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
