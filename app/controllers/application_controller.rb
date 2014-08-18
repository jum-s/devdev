class ApplicationController < ActionController::Base
before_filter :next_links
before_action :set_locale

  def next_links
    @next_articles = (Twtlink.last(6) + Autopost.last(4)).sample(5)
  end

  def has_video(post)
    video = true if post.url.include?("dailymo") || post.url.include?("youtu")
    video
  end

  def url_options
    { locale: I18n.locale }.merge(super)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
