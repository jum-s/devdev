class PostsController < ApplicationController
  include LanguageHelper

  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.order(created_at: :desc)
  end

  def feed
    twtlinks = serve_by_language(Twtlink.all, params[:locale]).last(10)
    autoposts = serve_by_language(Autopost.all, params[:locale]).last(4)
    autoposts_golden = autoposts.each{|f| f.title.prepend("[Golden] ")}
    
    @title = 'MyPosts'
    @posts = autoposts_golden + twtlinks
    @updated = @posts.first.updated_at unless @posts.empty?

    respond_to do |format|
      format.atom { render layout: false }
      format.rss { redirect_to feed_path(format: :atom), status: :moved_permanently }
    end
  end
end
