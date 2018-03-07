Rails.application.routes.draw do

  resources :expenses

  #if using update probably use patch? only changes the one field
  resources :trips, except: [:index, :edit] do
    resources :attendees, only: [:]
  end

  resources :payees, except: [:index, :new]

  #users/new(register), users/edit(update email, etc.), users/show(user homepage)
  resources :users, only: [:new, :edit, :show] 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
