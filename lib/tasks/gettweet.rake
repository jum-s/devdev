require 'json'
require 'oauth'

desc "Retrieve Jumijums tweet & store its links"
task gettweet: :environment do

  #TWEETER
  baseurl = "https://api.twitter.com"
  path    = "/1.1/statuses/user_timeline.json"
  query   = URI.encode_www_form("screen_name" => "Jumijums")
  address = URI("#{baseurl}#{path}?#{query}")
  request = Net::HTTP::Get.new address.request_uri
  http             = Net::HTTP.new address.host, address.port
  http.use_ssl     = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  consumer_key ||= OAuth::Consumer.new "kNTMGQSGEdRM5pyzdO663Pejp", "3WLQXHnTtGnpLYZGcfu0gKdMjeOjK0wMYjUa42lKIr7npE8Qmc"
  access_token ||= OAuth::Token.new "1721885928-GcpKSbRSnDj7fo21TD0oxOdkAsELNfvOlbTV57P", "7jt7fmfvR7kwn8LRMIp3RzfL44PzY5gyHf3ktJDiiBJIg"
  request.oauth! http, consumer_key, access_token
  http.start
  response = http.request request

  tweet = nil
  if response.code == '200' then
    tweet = JSON.parse(response.body)
  end
  #URL
  twt_urls = tweet.map { |t| t["entities"]["urls"][0]}.delete_if {|element| element == " " || element == "" || element.nil?}.map { |p| p["expanded_url"]}

  twt_urls.each do |url|
    #TEXT
    begin
      text_content = Readability::Document.new(open(url).read).content
    rescue
      text_content = nil
    end

    #WORD_COUNT
    word_count = text_content.split.count

    #TAGS  
    connect_alchemy = AlchemyAPI::Client.new('991ecc3d3a0f9e23afa918325deb016a7041b472')
    text_analysis = connect_alchemy.HTMLGetRankedKeywords(html: text_content)
    tags = text_analysis["keywords"].first(10).map {|v| v["text"]}.join(",")
    
    #TITLE
    alchemy_title = connect_alchemy.URLGetTitle(url: url)
    title = alchemy_title["title"] if alchemy_title["status"] == "OK"
    
    #LANG
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
                  language: language,
                  sentiment: sentiment,
                  word_count: word_count,
                  tag: tags)
  end
end