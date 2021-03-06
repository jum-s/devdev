class Twtlink < ActiveRecord::Base
  include ApiHelper
  include AttributeHelper
  include Scopes
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :text, :tag, :sentiment, :image, :language
  
  def new_urls
    json_response = JSON.parse(twitter_connect.body) if twitter_connect.code == '200'
    extended_urls = json_response.map do |t|
      t['entities']['urls'][0]
    end
    all_urls = extended_urls.compact.map { |p| p['expanded_url']}.compact
    actual_urls = Twtlink.all.map(&:url)
    all_urls - actual_urls
  end

  def create(new_urls)
    new_urls.each do |url|
      twt = Twtlink.new(url: url)
      get_attr(twt, url)
      twt.save
    end
  end
end
