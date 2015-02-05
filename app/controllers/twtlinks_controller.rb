class TwtlinksController < ApplicationController
  include LanguageHelper
  def index
    @twtlinks = serve_by_language(Twtlink.all, params[:locale]).page(params[:page]).per(30)
    @twtlink_videos = serve_by_language(Twtlink.all, params[:locale]).has_video.last 15
  end
end
