class AutopostsController < ApplicationController
  def index
    @autoposts = Autopost.order(:created_at).page(params[:page]).per(30)
    @autopost_videos = Autopost.order("created_at DESC")
                    				   .select{|auto| auto.url.include?("dailymo") || auto.url.include?("youtu") || auto.url.include?("vimeo")}
                    				   .last 15
  end
end