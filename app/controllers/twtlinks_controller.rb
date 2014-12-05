class TwtlinksController < ApplicationController
  def index
    @twtlinks = Twtlink.has_text.page(params[:page]).per(30)
    @twtlink_videos = Twtlink.has_video
  end
end