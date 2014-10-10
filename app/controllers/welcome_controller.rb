class WelcomeController < ApplicationController
  def index
    @pensee_random = Pensee.first.text.split("\", \"").sample
  	@posts = Post.order("created_at DESC").first(5)
    @autoposts = Autopost.order("created_at DESC").first(5)
  	@twtlinks = Twtlink.order("created_at DESC").first(10)
  end
end
