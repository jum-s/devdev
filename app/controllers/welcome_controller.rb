class WelcomeController < ApplicationController
  before_action :pensees_and_posts

  def index
    case params[:locale]
    when  'fr' then index_fr
    when 'en' then index_en
    else
      @autoposts = Autopost.has_text.first(5)
      @twtlinks = Twtlink.has_text.first(5)
    end
  end

  def index_en
    @autoposts = Autopost.has_text.in_english.first(5)
    @twtlinks = Twtlink.has_text.in_english.first(5)
  end

  def index_fr
    @autoposts = Autopost.has_text.in_french.first(5)
    @twtlinks = Twtlink.has_text.in_french.first(5)
  end

  def pensees_and_posts
    @pensee_random = Pensee.first.text.split("\", \"").sample
    @posts = Post.order('created_at DESC').first(5)
  end
end
