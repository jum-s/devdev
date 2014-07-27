class Autopost < ActiveRecord::Base
	validates_uniqueness_of :url
	attr_accessible :url, :pid, :title, :word_count, :has_video, :excerpt, :pocket_date, :text	
end
