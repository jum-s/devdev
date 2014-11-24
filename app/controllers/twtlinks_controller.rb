class TwtlinksController < ApplicationController
  def index
    @twtlinks = Twtlink.order("created_at DESC").select(&:text)
    @twtlink_videos = Twtlink.order("created_at DESC").select{|auto| auto.has_video==1}
  end
end
