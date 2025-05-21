Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/confirmation_sent', to: 'static_pages#confirmation_sent', as: :confirmation_sent 
  get "/today", to: 'lists#today', as: :today
  get "/upcoming", to: 'lists#upcoming', as: :upcoming
  get "/inbox", to: 'lists#inbox', as: :inbox
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    confirmations: 'users/confirmations'

  }
  devise_scope :user do
    get '/signup', to: 'users/registrations#new'
    get '/login', to: 'users/sessions#new'
    delete '/logout', to: 'users/sessions#destroy'
    get '/account/edit', to: 'users/registrations#edit'
  end  
end
