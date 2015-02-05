module AttributeHelper
  def connect_alchemy
    AlchemyAPI::Client.new(ENV['ALCHEMY_CONNECT'])
  end

  def connect_readability(url)
    Readability::Document.new(open(url).read)
    rescue nil
  end

  # Shared btw objopost & Twtlink #
  def get_attr(obj, url)
    obj.title      = get_title(url)
    obj.text       = get_text(url)
    obj.sentiment  = get_sentiment(url)
    obj.tag        = get_tags(url)
    obj.language   = get_language(url)
    obj.has_video  = 1 if a_video?(url)
    obj.word_count = get_word_count(obj.text) if obj.text
    obj.image      = get_image(url)
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