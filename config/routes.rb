Devdev::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  get '/feed', :controller => 'posts', :action => :feed, :defaults => { :format => 'atom' }

  root to: 'welcome#index'
  get '/fr' => 'welcome#index_fr'
  get '/en' => 'welcome#index_en'
  scope "/:locale" do
    resources :posts
    resources :autoposts
    resources :twtlinks
    get 'mois/cv'
    get 'mois/realisation'
    get 'mois/tour'
  end
end
