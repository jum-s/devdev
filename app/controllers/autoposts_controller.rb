class AutopostsController < ApplicationController
  def index
    @autoposts = Autopost.has_text.page(params[:page]).per(30)
    @autopost_videos = Autopost.has_video.last 15
  end
end