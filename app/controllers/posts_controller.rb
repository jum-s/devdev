class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.order("created_at DESC").all
  end

  def feed
    @title = 'MyPosts'
    @post = Post.order('updated_at desc')
    @updated = @post.first.updated_at unless @post.empty?

    respond_to do |format|
      format.atom { render layout: false }
      format.rss { redirect_to feed_path(format: :atom), status: :moved_permanently }
    end
  end
end
