class WelcomeController < ApplicationController
  before_action :pensees_and_posts

  def index
    @autoposts = @find_auto.first(5)
    @twtlinks = @find_twt.first(10)
  end

  def index_en
    @autoposts = @find_auto.select{|a| a.language == "english"}.first(5)
    @twtlinks = @find_twt.select{|a| a.language == "english"}.first(10)
    render "index"
  end

  def index_fr
    @autoposts = @find_auto.select{|a| a.language == "french"}.first(5)
    @twtlinks = @find_twt.select{|a| a.language == "french"}.first(10)
    render "index"
  end

private

  def pensees_and_posts
    @pensee_random = Pensee.first.text.split("\", \"").sample
    @posts = Post.order("created_at DESC").first(5)
    @find_auto = Autopost.order("created_at DESC").select(&:text)
    @find_twt = Twtlink.order("created_at DESC").select(&:text)

  end

end
