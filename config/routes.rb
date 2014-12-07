Devdev::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  get '/feed', :controller => 'posts', :action => :feed, :defaults => { :format => 'atom' }

  root to: 'welcome#index'
  scope "/:locale" do
    get '/' => 'welcome#index_fr'
    get '/' => 'welcome#index_en'
    resources :posts
    resources :autoposts
    resources :twtlinks
    get 'mois/cv'
    get 'mois/realisation'
    get 'mois/tour'
  end
end
