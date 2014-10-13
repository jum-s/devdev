class Twtlink < ActiveRecord::Base
  validates_uniqueness_of :url
  attr_accessible :url, :title, :word_count, :text, :tag, :sentiment, :image, :language

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
    new_urls = old_urls - all_urls
  end

  def create_with_url
    fetch_new_urls.each do |url|
      new_twt = Twtlink.new
      new_twt.url = url
      new_twt.get_title
      new_twt.get_image
      new_twt.get_text
      new_twt.save
    end
  end

  def get_title
    connect_alchemy = AlchemyAPI::Client.new(ENV['ALCHEMY_CONNECT'])
    alchemy_title = connect_alchemy.URLGetTitle(url: url)
    self.title = alchemy_title["title"] if alchemy_title["status"] == "OK"
  end

  def connect_readability(url)
    begin
      read_connect = Readability::Document.new(open(self.url).read)
    rescue
      nil
    end
  end

  def get_image
    self.image = connect_readability(self.url).images[0]
  end

  def get_text
    self.text = connect_readability(self.url).content
    # word_count = text_content.split.count
  end

end
