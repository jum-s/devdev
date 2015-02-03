class AutopostsController < ApplicationController
  def index
      @autoposts = Autopost.language(params[:locale]).page(params[:page]).per(30)
      @autopost_videos = Autopost.has_video.language(params[:locale]).last 15
  end

  def create
    token_check
    Autopost.create_with_url(auto_params)
  end

  private
 
  def auto_params
    params.require(:url)
  end

  def token_check
    redirect_to root_url unless request.env["HTTP_TOKEN"] == ENV['LOCAL_TOKEN']
  end
end
