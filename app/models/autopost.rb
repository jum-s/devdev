class Autopost < ActiveRecord::Base
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :has_video, :text, :tag, :sentiment, :image, :language
 
  def get_all_entries
    feeds = Feedjira::Feed.fetch_and_parse("https://www.framabag.org/u/jumijums/?feed&type=home&user_id=1&token=" + ENV['SECRET_KEY']).entries
    raw_entries = feeds.map do |raw_entry| 
      {title: raw_entry['title'], url: raw_entry['url']}
    end
  end

  def only_new_entries
    actual_entries = Autopost.all.map(&:url)
    new_entries = get_all_entries.reject { |entry| entry if actual_entries.include? entry[:url] || entry[:title] == "Untitled" }
  end

  def self.add_new
    auto = Autopost.new
    auto.only_new_entries.each do |entry|
      aut = Autopost.new
      aut.title = entry[:title]
      aut.clean_url(entry[:url])
      aut.text_content(aut.url) if aut.has_video == 0
      aut.text_analysis(aut.text) if aut.text != nil
      aut.save
    end
  end
  

  def clean_url(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host)
    response = http.get(uri.path)
    begin
      self.url = uri.to_s
      unless has_a_video(self.url)
        self.url = response.fetch('location') if response.code != "200" 
      end
    rescue
    end
  end

  def text_content(url)
    begin
      read_connect = Readability::Document.new(open(url).read)
      text_content = read_connect.content.force_encoding("UTF-8")
      self.word_count = strip_tags(text_content).split(' ').count
      self.reading_time = get_reading_time(self.word_count)
      self.image = read_connect.images[0]
      self.text = text_content
    rescue
    end
  end

  def get_reading_time(word_count)
    words_per_minute = 170.0
    time = word_count / words_per_minute
    reading_time = "#{time.round} min"
    if time < 1
            reading_time = "< 1 min"
    elsif time >= 1 && time < 1.6
            reading_time = "1 min"
    end
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