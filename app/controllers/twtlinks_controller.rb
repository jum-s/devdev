class TwtlinksController < ApplicationController
  def index
    @twtlinks = Twtlink.order("created_at DESC").select(&:text)
    @twtlink_videos = Twtlink.order("created_at DESC")
                                           .select{|twt| twt.url.include?("dailymo") || twt.url.include?("youtu") || twt.url.include?("vimeo")}
                                           .last 15  
  end
end
