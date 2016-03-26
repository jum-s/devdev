class MainController < ApplicationController
  before_action :pensees_and_posts
  include LanguageHelper

  def index
    @twtlinks = serve_by_language(Twtlink.all, params[:locale]).first(10)
    @autoposts = serve_by_language(Autopost.all, params[:locale]).first(4)
  end

  def pensees_and_posts
    @pensee_random = Pensee.first.text.split("\", \"").sample
    @posts = Post.order('created_at DESC').first(5)
  end

  def tour
  end
end
