ActiveadminDepot::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  get "cart" => "cart#show"
  get "cart/add/:id" => "cart#add", :as => :add_to_cart
  post "cart/remove/:id" => "cart#remove", :as => :remove_from_cart
  match "cart/checkout" => "cart#checkout", :as => :checkout
  match "cart/confirm" => "cart#confirm", :as => :confirm
  post "pagseguro_developer", :to => "pag_seguro/developer#create"

  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  resources :sessions
  resources :users
  resources :products

  root :to => "products#index"
end
