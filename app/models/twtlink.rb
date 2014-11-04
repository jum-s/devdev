class Twtlink < ActiveRecord::Base
  include ApplicationHelper 
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :text, :tag, :sentiment, :image, :language

  def create_with_url
    fetch_new_urls.each do |url|
      twt = Twtlink.new
      twt.url = url
      begin
        twt.title = connect_alchemy.URLGetTitle(url: url)["title"]
        twt.text = connect_readability(url).content
        twt.image = connect_readability(url).images[0]
        twt.word_count = twt.text.split(' ').count
        twt.reading_time = get_reading_time(twt)
        twt.sentiment = get_sentiment(twt.text)
        twt.tag = get_tags
        twt.language = get_language
      rescue
      end
      twt.save
    end
  end

  def get_sentiment(text)
    sentiment_response = connect_alchemy.HTMLGetTextSentiment(html: text)
    sentiment_score = sentiment_response["docSentiment"]["score"] if sentiment_response["status"] == "OK"
    case sentiment_score
      when 0.1..1 then 1
      when -0.1..-1 then 3
      else 2
    end
  end

  def get_language
    text_analysis = connect_alchemy.HTMLGetRankedKeywords(html: self.text)
    text_analysis["language"]
  end

  def get_tags
    text_analysis = connect_alchemy.HTMLGetRankedKeywords(html: self.text)
    text_analysis["keywords"].first(10).map {|v| v["text"]}.join(",")
  end
end
