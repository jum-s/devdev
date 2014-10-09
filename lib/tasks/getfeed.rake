desc "Get/retrieve feed infos from framabag, filter, and add to database if don't exist"

task getfeed: :environment do
  feeds = Feedjira::Feed.fetch_and_parse("https://www.framabag.org/u/jumijums/?feed&type=home&user_id=1&token=" + ENV['SECRET_KEY']).entries
  entries = feeds.map { |raw_entry| {title: raw_entry['title'],
                                date: raw_entry['published'],
                                url: raw_entry['url']}}
  auto_url = Autopost.all.map {|p| p.url}
  new_entries = entries.reject { |entry| entry if auto_url.include? entry[:url] }
  new_entries.each do |entry|
    # fetch long url
    begin
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host)
      response = http.get(uri.path)
      url = response.fetch('location') if response.code != "200"
    rescue
    end
    begin
      read_connect = Readability::Document.new(open(entry[:url]).read)
      text_content = read_connect.content.force_encoding("UTF-8")
      word_count = text_content.split.count
      image = read_connect.images[0]
    rescue
      text_content = nil
    end
    if text_content != nil
      connect_alchemy = AlchemyAPI::Client.new(ENV['ALCHEMY_CONNECT'])
      
      text_analysis = connect_alchemy.HTMLGetRankedKeywords(html: text_content)
      tags = text_analysis["keywords"].first(6).map {|v| v["text"]}.join(",")
      language = text_analysis["language"]
  
      begin  
        sentiment_score = (connect_alchemy.HTMLGetTextSentiment(html: text_content)["docSentiment"]["score"].to_f * 100).round if language == "english"
      rescue
      end

      if sentiment_score == nil
        sentiment = nil 
      elsif sentiment_score >= 10
        sentiment = 1 
      elsif sentiment_score <= -10
        sentiment = 3
      else 
        sentiment = 2
      end

      Autopost.create(
        url: entry[:url], 
        title: entry[:title], 
        word_count: word_count,
        text: text_content,
        tag: tags,
        language: language,
        sentiment: sentiment,
        image: image,
        pocket_date: entry[:date]) if entry[:title] != nil
    end
  end
end

