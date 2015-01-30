class TwtlinksController < ApplicationController
  def index
      @twtlinks = Twtlink.language(params[:locale]).page(params[:page]).per(30)
      @twtlink_videos = Twtlink.has_video.language(params[:locale]).last 15
  end
end
