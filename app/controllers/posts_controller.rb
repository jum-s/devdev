class PostsController < ApplicationController
def new
	@post = Post.new	
end

def show
	@post = Post.find(params[:id])
end

def index
	@post = Post.order("created_at DESC").all
end

def create
	  @post = Post.new(post_params)
	if @post.save && user_signed_in?
		redirect_to '/'
	else
		render 'new'
	end
end

def edit
  @post = Post.find(params[:id])
end


def update
	@post = Post.find(params[:id])
  if @post.update(post_params)
	redirect_to :post
  else
    render 'edit'
  end
end

def destroy
	@post = Post.find(params[:id])
	@post.destroy
	redirect_to '/'
end

def feed
	@title = "MyPosts"
  @post = Post.order("updated_at desc")
	@updated = @post.first.updated_at unless @post.empty?
	
	respond_to do |format|
    format.atom { render :layout => false }
		format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
	end
end

private
	def post_params
	    params.require(:post).permit(:title, :text)
	end
end
