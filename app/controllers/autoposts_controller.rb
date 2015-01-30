class AutopostsController < ApplicationController
  def index
      @autoposts = Autopost.language(params[:locale]).page(params[:page]).per(30)
      @autopost_videos = Autopost.has_video.language(params[:locale]).last 15
  end
end
