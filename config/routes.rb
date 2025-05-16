Rails.application.routes.draw do
  root to: 'static_pages#home'
  # asをつけることで、パスの名前付きヘルパーconfirmation_sent_pathを生成できる
  get '/confirmation_sent', to: 'static_pages#confirmation_sent', as: :confirmation_sent 
  devise_for :users, controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  devise_scope :user do
    get '/signup', to: 'users/registrations#new'
    get '/login', to: 'users/sessions#new'
    delete '/logout', to: 'users/sessions#destroy'
  end  
end
