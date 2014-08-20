class Autopost < ActiveRecord::Base
	validates_uniqueness_of :url
	attr_accessible :url, :title, :word_count, :has_video, :pocket_date, :text, :tag, :sentiment, :image, :language
end
