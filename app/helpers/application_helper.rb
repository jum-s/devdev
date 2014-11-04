module ApplicationHelper
  # Estimation of the time to read a post, Merci Em-AK !
 
 def twitter_connect
    baseurl = "https://api.twitter.com"
    path    = "/1.1/statuses/user_timeline.json"
    query   = URI.encode_www_form("screen_name" => "Jumijums")
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

  def fetch_new_urls
    tweets_ary = JSON.parse(twitter_connect.body) if twitter_connect.code == '200'
    all_urls = tweets_ary.map{ |t| t["entities"]["urls"][0]}
                         .compact
                         .map { |p| p["expanded_url"]}
                         .compact

    old_urls = Twtlink.all.map(&:url)
    new_urls = all_urls - old_urls
  end

  def connect_readability(url)
    begin
      Readability::Document.new(open(url).read)
    rescue
      nil
    end
  end

  def get_reading_time(post)
    words_per_minute = 170.0
    time = post.word_count / words_per_minute
    reading_time = "#{time.round} min"
    if time < 1
            reading_time = "< 1 min"
    elsif time >= 1 && time < 1.6
            reading_time = "1 min"
    end
    reading_time
  end

  def connect_alchemy
     AlchemyAPI::Client.new(ENV['ALCHEMY_CONNECT'])
  end

  def get_date(post)
    post.created_at.strftime("%e %b.")
  end

  def get_language(post)
    case post.language 
      when "english" then " | #{image_tag 'uk.png', size: '20x20'}".html_safe
      when "french" then " | #{image_tag 'fr.png', size: '20x20'}".html_safe
      else
    end
  end

  def get_sentiment(post)
    case post.sentiment 
      when 1 then " | #{icon('smile-o')}".html_safe
      when 2 then " | #{icon('meh-o')}".html_safe
      when 3 then " | #{icon('frown-o')}".html_safe
      else
    end
  end

  def get_video(post)
    if post.url.include?("dailymo") || post.url.include?("youtu")
      post.has_video = true 
    end
  end

  def random_color
    color_array = [
      "rgba(232, 202, 179, 0.6)", 
      "rgba(225, 226, 117, 0.6)", 
      "rgba(255, 125, 132, 0.6)", 
      "rgba(190, 102, 232, 0.6)", 
      "rgba(112, 134, 255, 0.6)", 
      "rgba(247, 122, 82, 0.6)", 
      "rgba(255, 151, 79, 0.6)"]
    color_array.sample
  end
end