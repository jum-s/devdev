module ApiHelper
  def twitter_connect
    baseurl = 'https://api.twitter.com/1.1/statuses/user_timeline.json'
    query   = URI.encode_www_form('screen_name' => 'Jumijums')
    address = URI("#{baseurl}?#{query}&count=50")
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

  def framabag_urls
    feeds = Feedjira::Feed.fetch_and_parse('https://www.framabag.org/u/jumijums/?feed&type=home&user_id=1&token=' + ENV['SECRET_KEY'], {:ssl_verify_peer => false}).entries
    feeds.map(&:url)
  end

  def new_urls
    autopost_urls = Autopost.all.map(&:url)
    framabag_urls - autopost_urls
  end
end
