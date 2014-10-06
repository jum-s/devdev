class TwtlinksController < ApplicationController
  def index
    @twtlinks = Twtlink.order("created_at DESC").all
  end
end
