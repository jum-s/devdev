class AutopostsController < ApplicationController
  def index
    if params[:locale] == 'fr'
      @autoposts = Autopost.has_text.in_french.page(params[:page]).per(30)
      @autopost_videos = Autopost.has_video.in_french.last 15
    else
      @autoposts = Autopost.has_text.in_english.page(params[:page]).per(30)
      @autopost_videos = Autopost.has_video.in_english.last 15
    end
  end
end
