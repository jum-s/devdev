class ApplicationController < ActionController::Base
  before_filter :next_links
  before_action :set_locale

  def next_links
    twtlinks = serve_by_language(Twtlink.all, params[:locale])
    autoposts = serve_by_language(Autopost.all, params[:locale])
    @next_articles = (twtlinks.last(6) + autoposts.last(4)).sample(5)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
