Devdev::Application.routes.draw do
  get 'welcome/index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "welcome/index"
  get '/feed', :controller => 'posts', :action => :feed, :defaults => { :format => 'atom' }

  resources :autoposts
  root to: 'welcome#index'
  resources :posts
end
