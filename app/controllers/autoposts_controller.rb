class AutopostsController < ApplicationController
  def index
    @autoposts = Autopost.order("pocket_date DESC").all
  end

  def show
    @autopost = Autopost.find(params[:id])
    redirect_to @autopost.url if has_video(@autopost) == true
  end
end