class TwtlinksController < ApplicationController
  def index
    if params[:locale] == 'fr'
      @twtlinks = Twtlink.has_text.in_french.page(params[:page]).per(30)
      @twtlink_videos = Twtlink.has_video.in_french.last 15
    elsif params[:locale] == 'en'
      @twtlinks = Twtlink.has_text.in_english.page(params[:page]).per(30)
      @twtlink_videos = Twtlink.has_video.in_english.last 15
    else
      @twtlinks = Twtlink.has_text.page(params[:page]).per(30)
      @twtlink_videos = Twtlink.has_video.last 15
    end
  end
end
