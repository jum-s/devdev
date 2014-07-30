Devdev::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/feed', :controller => 'posts', :action => :feed, :defaults => { :format => 'atom' }
  root to: 'welcome#index'
  
  resources :autoposts
  resources :posts
  get 'mois/cv'
  get 'mois/realisation'
  get 'mois/tour'
  get 'welcome/index'
end
