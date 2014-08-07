class AutopostsController < ApplicationController
  def video
    videos = Autopost.order("pocket_date DESC").all.select { |auto| auto.has_video == 2 && auto.url.include?("youtube") }
    @youtubes = videos.map {|v| "http://www.youtube.com/embed/" + v.url[-11..-1]}
  end

  def index
    @autoposts = Autopost.order("pocket_date DESC").all
  end

  def show
    @autopost = Autopost.find(params[:id])
    @next_autoposts = Autopost.order("pocket_date DESC").last(4)
  end
end

