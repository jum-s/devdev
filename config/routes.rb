Devdev::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  get '/feed', controller: 'posts', action: :feed, defaults: { format: 'atom' }

  root to: 'welcome#index'
  resources :autoposts
  resources :twtlinks
  resources :posts
  # get 'mois/cv'
  get 'mois/realisation'
  get 'mois/tour'
  scope "/:locale" do
    get '/' => 'welcome#index'
    resources :posts
    resources :autoposts
    resources :twtlinks
    # get 'mois/cv'
    get 'mois/realisation'
    get 'mois/tour'
  end
end
