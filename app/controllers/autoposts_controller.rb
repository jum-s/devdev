class AutopostsController < ApplicationController
  def index
    @autoposts = Autopost.order("pocket_date DESC").all
  end
end