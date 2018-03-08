Rails.application.routes.draw do

  resources :expenses, except: [:index, :new] do  
    resources :payees, only: [:create, :destroy]
  end

  # if using update probably use patch? only changes the one field
  # have only got create and destroy attendees within the trip 
  resources :trips, except: [:index, :edit] do
    resources :attendees, only: [:create, :destroy]
  end

  # resources :sessions, except: [:index, :edit, :update]

  #users/new(register), users/edit(update email, etc.), users/show(user homepage)
  resources :users, only: [:new, :create, :edit, :show] 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 get '/login' => 'users#new'
 post '/users' => 'users#create'

#  get '/login' => 'sessions#new'
 post '/login' => 'sessions#create'
 get '/logout' => 'sessions#destroy'



end
