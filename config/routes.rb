Devdev::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  get '/feed', controller: 'posts', action: :feed, defaults: { format: 'atom' }

  root to: 'main#index'
  resources :autoposts
  resources :twtlinks
  resources :posts
  get 'main/tour'
  scope "/:locale" do
    get '/' => 'main#index'
    resources :posts
    resources :autoposts
    resources :twtlinks
    get 'main/tour'
  end
end
