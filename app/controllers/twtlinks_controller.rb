class TwtlinksController < ApplicationController
  def index
    @twtlinks = Twtlink.order("created_at DESC").all
  end

  def show
    @twtlink = Twtlink.find(params[:id])
    redirect_to @twtlink.url if has_video(@twtlink) == true
  end
end
