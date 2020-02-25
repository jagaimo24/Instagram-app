Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/search',  to: 'search#search'
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions:      'users/sessions',
    passwords:     'users/passwords'
  }
  if Rails.env.development?  
    mount LetterOpenerWeb::Engine, at: "/letter_opener"  
  end 
  
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources   :users,          only: [:show, :index, :destroy]
  resources   :microposts,     only: [:index, :show, :create, :destroy] do
    resources :comments,       only: [:create, :destroy]
    end
  resources   :relationships,  only: [:create, :destroy]
  resources   :likes,          only: [:create, :destroy]
  resources :notifications,    only: :index
end
