class Twtlink < ActiveRecord::Base
  include ApplicationHelper
  include ApiHelper 
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :text, :tag, :sentiment, :image, :language

  scope :has_video, ->  { where("url like ?", "%youtu%" || "%vimeo%" || "%dailymo%").order(created_at: :desc) }
  scope :has_text, ->  { where.not(text: nil).order(created_at: :desc)}
  scope :in_french, ->  { where(language: "french").order(created_at: :desc)}
  scope :in_english, ->  { where.not(language: "french").order(created_at: :desc)}

  def new_urls
    json_response = JSON.parse(twitter_connect.body) if twitter_connect.code == '200'
    all_urls = json_response.map{ |t| t["entities"]["urls"][0]}.compact.map { |p| p["expanded_url"]}.compact
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
      twt.has_video = 1 if has_a_video(url)
      twt.text = get_text(url)
      twt.word_count = get_word_count(twt.text)
      twt.image = get_image(url)
      twt.save
    end
  end
end
