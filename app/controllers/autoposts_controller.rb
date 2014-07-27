class AutopostsController < ApplicationController
	def index
		@autoposts = Autopost.order("pocket_date DESC").all
	end

	def show
		@autopost = Autopost.find(params[:id])
	end
end
