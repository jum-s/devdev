class TwtlinksController < ApplicationController
  def index
    @twtlinks = Twtlink.order("created_at DESC").all
  end

  def show
    @twtlink = Twtlink.find(params[:id])
  end
end
