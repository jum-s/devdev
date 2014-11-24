class AutopostsController < ApplicationController
  def index
    @autoposts = Autopost.order("created_at DESC").select(&:text)
    @autopost_videos = Autopost.order("created_at DESC").select{|auto| auto.has_video==1}
  end
end