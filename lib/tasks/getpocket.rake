require 'alchemy-api'
require "faraday"
require "json"
# Run periodically with the heroku scheduler 

desc "Get/retrieve Pocket infos, filter, and add to database if don't exist"
task getpocket: :environment do
  
  # Set up builder URL to access Pocket API, thx to Faraday gem
  conn = Faraday.new(:url => 'https://getpocket.com') do |f|
    f.request  :url_encoded
    f.response :logger
    f.adapter Faraday.default_adapter
  end
  
  # Get command to retrieve awesome articles on your Pocket account
  # (If you dont use the API service yet, go to 'add your app')
  res = conn.post('/v3/get', { access_token: 'bfc34621-a00f-5686-3dca-4d6e64',
                 consumer_key: '20330-61b6e9152b48e7fc41e68842' })
    
  # JSON is native to rails, render a beautiful nested array
  array = JSON.parse(res.body)

  # map.method = GREAT !
  listfinal = array['list'].map { |v| {item_id: v[1]['item_id'],
                                       url: v[1]['resolved_url'],
                                       title: v[1]['resolved_title'],
                                       excerpt: v[1]['excerpt'],
                                       has_video: v[1]['has_video'],
                                       pocket_date_epoch: v[1]['time_updated'],
                                       word_count: v[1]['word_count']} }
  listfinal.each do |h|
    # create date
    updated_datetime = Time.at(h[:pocket_date_epoch].to_i).strftime("%d/%m/%Y")  
    
    # extract content with readability gem
    begin
      read_connect = Readability::Document.new(open(h[:url]).read)
      text_content = read_connect.content
      word_count = text_content.split.count
      image = read_connect.images[0]
    rescue
      text_content = nil
    end

    #Autotag through Alchemy API  
    connect_alchemy = AlchemyAPI::Client.new('991ecc3d3a0f9e23afa918325deb016a7041b472')
    
    text_analysis = connect_alchemy.HTMLGetRankedKeywords(html: text_content)
    tags = text_analysis["keywords"].first(6).map {|v| v["text"]}.join(",")
    language = text_analysis["language"]
    

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
    Autopost.create(url: h[:url], 
                    pid: h[:item_id], 
                    title: h[:title], 
                    excerpt: h[:excerpt],
                    has_video: h[:has_video],
                    word_count: h[:word_count],
                    text: text_content,
                    tag: tags,
                    language: language,
                    sentiment: sentiment,
                    image: image,
                    pocket_date: updated_datetime) if text_content != nil
  end
end
# Merci Andrei !