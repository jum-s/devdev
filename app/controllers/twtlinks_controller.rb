class TwtlinksController < ApplicationController
  def index
    @twtlinks = Twtlink.order("created_at DESC").all
  end

  def show
    @twtlink = Twtlink.find(params[:id])
    @next_twtlinks = Twtlink.order("created_at DESC").last(4)
  end
end
