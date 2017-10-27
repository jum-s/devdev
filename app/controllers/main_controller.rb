class MainController < ApplicationController
  include LanguageHelper

  def index
    @twtlinks = serve_by_language(Twtlink.all, params[:locale]).first(10)
    @autoposts = serve_by_language(Autopost.all, params[:locale]).first(4)
  end

  def tour
  end
end
