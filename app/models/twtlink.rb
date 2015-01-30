class Twtlink < ActiveRecord::Base
  include ApiHelper
  include Scopes
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :text, :tag, :sentiment, :image, :language

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
    json_response = JSON.parse(twitter_connect.body) if twitter_connect.code == '200'
    all_urls = json_response.map{ |t| t['entities']['urls'][0]}.compact.map { |p| p['expanded_url']}.compact
    actual_urls = Twtlink.all.map(&:url)
    all_urls - actual_urls
  end

  def create_twtlinks
    new_urls.each do |url|
      twt = Twtlink.new
      twt.url = url
      twt.title = get_title(url)
      twt.sentiment = get_sentiment(url)
      twt.tag = get_tags(url)
      twt.language = get_language(url)
      twt.has_video = 1 if a_video?(url)
      twt.text = get_text(url)
      twt.word_count = get_word_count(twt.text)
      twt.image = get_image(url)
      twt.save
    end
  end
end
