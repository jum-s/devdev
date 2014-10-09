require 'json'
require 'oauth'

desc "Retrieve Jumijums tweet & store links"
task gettwt: :environment do

  #TWEETER
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
  response = http.request request

  tweet = nil
  tweet = JSON.parse(response.body) if response.code == '200'
  #URL
  twt_urls = tweet.map { |t| t["entities"]["urls"][0]}.delete_if {|element| element == " " || element == "" || element.nil?}.map { |p| p["expanded_url"]}

  twt_urls.each do |url|
    # fetch long url
    begin
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host)
      response = http.get(uri.path)
      url = response.fetch('location') if response.code != "200"
    rescue
    end
    #TEXT & WORD_COUNT
    begin
      read_connect = Readability::Document.new(open(url).read)
      text_content = read_connect.content
      word_count = text_content.split.count
      image = read_connect.images[0]
    rescue
      text_content = nil
    end

    connect_alchemy = AlchemyAPI::Client.new(ENV['ALCHEMY_CONNECT'])
    
    #TITLE
    alchemy_title = connect_alchemy.URLGetTitle(url: url)
    title = alchemy_title["title"] if alchemy_title["status"] == "OK"

    text_analysis = connect_alchemy.HTMLGetRankedKeywords(html: text_content)

    #TAGS & LANG
    tags = text_analysis["keywords"].first(10).map {|v| v["text"]}.join(",")
    language = text_analysis["language"]

    #SENTIMENT    
    sentiment_score = (connect_alchemy.HTMLGetTextSentiment(html: text_content)["docSentiment"]["score"].to_f * 100).round if language == "english"
    if sentiment_score == nil
      sentiment = nil 
    elsif sentiment_score >= 10
      sentiment = 1 
    elsif sentiment_score <= -10
      sentiment = 3
    else 
      sentiment = 2
    end

    Twtlink.create(url: url, 
                  title: title, 
                  text: text_content,
                  image: image,
                  language: language,
                  sentiment: sentiment,
                  word_count: word_count,
                  tag: tags) if title != nil
  end
end
