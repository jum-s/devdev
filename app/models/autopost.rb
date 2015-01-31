class Autopost < ActiveRecord::Base
  include ApiHelper
  include Scopes
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :has_video, :text, :tag, :sentiment, :image, :language

  def self.language(locale)
    case locale
    when 'fr'
      has_title.where(language: 'french') 
    when 'en'
      has_title.where(language: 'english')
    else 
      has_title
    end
  end

  def new_urls
    autopost_urls = Autopost.all.map(&:url)
    framabag_urls - autopost_urls
  end

  def create_autoposts
    new_urls.each do |url|
      aut = Autopost.new
      aut.url        = url
      aut.title      = get_title(url)
      aut.sentiment  = get_sentiment(url)
      aut.tag        = get_tags(url)
      aut.language   = get_language(url)
      aut.has_video  = 1 if a_video?(url)
      aut.text       = get_text(url)
      aut.word_count = get_word_count(aut.text) if aut.text
      aut.image      = get_image(url)
      aut.save
    end unless Autopost.new.new_urls.empty?
  end
end
