class Autopost < ActiveRecord::Base
  include ApplicationHelper 
  include ApiHelper 
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :has_video, :text, :tag, :sentiment, :image, :language
  
  scope :has_video, ->  { where("url like ?", "%youtu%" || "%vimeo%" || "%dailymo%").order(created_at: :desc) }
  scope :has_text, ->  { where.not(text: nil).order(created_at: :desc)}
  scope :in_french, ->  { where(language: "french").order(created_at: :desc)}
  scope :in_english, ->  { where.not(language: "french").order(created_at: :desc)}

  def new_urls
    actual_urls = Autopost.all.map(&:url)
    framabag_connect
  end  
 
  def create_autoposts
    Autopost.new.new_urls.each do |url|
      aut = Autopost.new
      aut.url = url
      aut.title = get_title(url)
      aut.sentiment = get_sentiment(url)
      aut.tag = get_tags(url)
      aut.language = get_language(url)
      aut.has_video = 1 if has_a_video(url)
      aut.text = get_text(url)
      aut.word_count = get_word_count(aut.text) if aut.text
      aut.image = get_image(url)
      aut.save
    end unless Autopost.new.new_urls.empty?
  end
end