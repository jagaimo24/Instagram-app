Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/show',    to: 'static_pages#show'

  devise_for :users, controllers: {
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
  
  resources  :users, only: [:show, :index, :destroy]
  resources :microposts, only: [:index, :show, :create]
end
