class WelcomeController < ApplicationController
  before_action :pensees_and_posts

  def index
    @twtlinks = Twtlink.language(params[:locale]).first(8)
    @autoposts = Autopost.language(params[:locale]).first(4)
  end

  def pensees_and_posts
    @pensee_random = Pensee.first.text.split("\", \"").sample
    @posts = Post.order('created_at DESC').first(5)
  end
end
