class AutopostsController < ApplicationController
	def index
    @autoposts = Autopost.order("pocket_date DESC").all
  end

  def show
    @autopost = Autopost.find(params[:id])
		@next_autoposts = Autopost.order("pocket_date DESC").last(4)
	end
end
