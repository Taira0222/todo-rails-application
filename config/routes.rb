Rails.application.routes.draw do
  root to: 'static_pages#home'
  devise_for :users, controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  devise_scope :user do
    get '/signup', to: 'devise/registrations#new'
    get '/login', to: 'devise/sessions#new'
    delete '/logout', to: 'devise/sessions#destroy'
  end  
end
