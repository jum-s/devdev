class Autopost < ActiveRecord::Base
	validates_uniqueness_of :url
	attr_accessible :url, :title, :word_count, :has_video, :pocket_date, :text, :tag, :sentiment, :image, :language

  def self.add_new
    auto = Autopost.new
    entries = auto.get_entries(entries)
    entries.each do |entry|
      aut = Autopost.new
      aut.title = entry[:title]
      aut.clean_url(entry[:url])
      aut.text_content(aut.url)
      aut.text_analysis(aut.text) if aut.text != nil
      aut.save
    end
  end

  def get_entries(new_entries)
    feeds = Feedjira::Feed.fetch_and_parse("https://www.framabag.org/u/jumijums/?feed&type=home&user_id=1&token=" + ENV['SECRET_KEY']).entries
    raw_entries = feeds.map do |raw_entry| 
      {title: raw_entry['title'], url: raw_entry['url']}
    end
    auto_urls = Autopost.all.map(&:url)
    new_entries = raw_entries.reject { |entry| entry if auto_urls.include? entry[:url] }
  end

  def clean_url(url)
    begin
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host)
      response = http.get(uri.path)
      url = response.fetch('location') if response.code != "200"
    rescue
      self.url = url
    end   
  end

  def text_content(url)
    begin
      read_connect = Readability::Document.new(open(url).read)
      text_content = read_connect.content.force_encoding("UTF-8")
      self.word_count = text_content.split.count
      self.image = read_connect.images[0]
      self.text = text_content
    rescue
      text_content = nil
    end
    self.text = text_content
  end

  def text_analysis(text)
    alchemy = AlchemyAPI::Client.new(ENV['ALCHEMY_CONNECT'])
    
    begin
      sentiment_score = (alchemy.TextGetTextSentiment(text: text)["docSentiment"]["score"].to_f * 100).round if language == "english"
    rescue      
      sentiment_score = 2
    end
    
    text_analysis = alchemy.TextGetRankedKeywords(text: text)
    self.tag = text_analysis["keywords"].first(6).map {|v| v["text"]}.join(",")
    self.language = text_analysis["language"]
    
    self.sentiment = case sentiment_score
      when 10..200 then 1
      when -10..-200 then 3
      else 2
    end
  end
end