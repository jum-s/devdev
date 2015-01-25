module ApiHelper
  def twitter_connect
    baseurl = 'https://api.twitter.com'
    path    = '/1.1/statuses/user_timeline.json'
    query   = URI.encode_www_form('screen_name' => 'Jumijums')
    address = URI("#{baseurl}#{path}?#{query}")
    request = Net::HTTP::Get.new address.request_uri
    http             = Net::HTTP.new address.host, address.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    consumer_key ||= OAuth::Consumer.new(ENV['TWTSECRET1'], ENV['TWTSECRET2'])
    access_token ||= OAuth::Token.new(ENV['TWTSECRET4'], ENV['TWTSECRET3'])
    request.oauth! http, consumer_key, access_token
    http.start
    http.request request
  end

  def framabag_connect
    feeds = Feedjira::Feed.fetch_and_parse('https://www.framabag.org/u/jumijums/?feed&type=home&user_id=1&token=' + ENV['SECRET_KEY']).entries
    feeds.map { |feed| feed['url'] }
  end

# Shared btw Autopost & Twtlink #

  def connect_alchemy
    AlchemyAPI::Client.new(ENV['ALCHEMY_CONNECT'])
  end

  def connect_readability(url)
    Readability::Document.new(open(url).read)
    rescue nil
  end

  def get_title(url)
    connect_alchemy.URLGetTitle(url: url)['title']
  end
  
  def get_text(url)
    begin
      connect_readability(url).content 
    rescue 
      ''
    end
  end
  
  def get_word_count(text)
    text.split(' ').count
  end
  
  def get_image(url)
    begin
      image = connect_readability(url).images[0]
      return image if image =~ /\A#{URI.regexp(['http', 'https'])}\z/
    rescue 
      ''
    end
  end
  
  def get_sentiment(url)
    begin
      sentiment_response = connect_alchemy.URLGetTextSentiment(url: url)
      sentiment_score = sentiment_response['docSentiment']['score'] if sentiment_response['status'] == 'OK'
      case sentiment_score
      when 0.05..1 then 1
      when -0.05..-1 then 3
      else 2
      end
    rescue
      2
    end
  end

  def get_tags(url)
    begin
      text_analysis = connect_alchemy.URLGetRankedKeywords(url: url)
      text_analysis['keywords'].first(10).map {|v| v['text']}.join(',')
    rescue 
      ''
    end
  end

  def get_language(url)
    begin
      text_analysis = connect_alchemy.URLGetRankedKeywords(url: url)
      text_analysis['language']
    rescue 
      ''
    end
  end

  def a_video?(url)
    url.include?('dailymo') || url.include?('youtu')|| url.include?('vimeo')
  end

  def clean_url(url)
    begin
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host)
      if url.include? 'youtub'
        self.url = uri.to_s
      else
        response = http.get(uri.path)
        self.url = response.fetch('location') if response.code != '200'
      end
    rescue
    end
  end
end
