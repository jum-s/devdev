class AutopostsController < ApplicationController
  def index
    @autoposts = Autopost.order("created_at DESC").all
  end
end