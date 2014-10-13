class Twtlink < ActiveRecord::Base
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :text, :tag, :sentiment, :image, :language

  def self.twitter_connect
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

  def self.fetch_new_urls
    tweets_ary = JSON.parse(twitter_connect.body) if twitter_connect.code == '200'
    all_urls = tweets_ary.map{ |t| t["entities"]["urls"][0]}
                         .compact
                         .map { |p| p["expanded_url"]}
    clean_urls = clean_urls(all_urls)
    old_urls = Twtlink.all.map(&:url)
    new_urls = old_urls - all_urls
  end

  def self.clean_urls(all_urls)
    ["http://ow.ly/CBhWO"]
  end
end
