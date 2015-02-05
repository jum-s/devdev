class Autopost < ActiveRecord::Base
  include ApiHelper
  include Scopes
  include AttributeHelper
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :has_video, :text, :tag, :sentiment, :image, :language

  def create_from_framabag_urls
    new_urls.each do |url|
      Autopost.new.create_with_url(url)
    end
  end

  def create_with_url(url)
    self.url = url
    get_attr(self, url)
    self.save
    puts "ok"
  end
end
