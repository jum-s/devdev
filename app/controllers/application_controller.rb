class ApplicationController < ActionController::Base
before_filter :next_links

  def next_links
    @next_articles = (Twtlink.last(6) + Autopost.last(4)).sample(5)
  end
end
