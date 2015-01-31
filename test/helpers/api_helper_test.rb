class ApiHelperTest < ActionView::TestCase
  test "twitter connect" do
    VCR.use_cassette('api_helper') do
      assert_equal twitter_connect.content_type, "application/json"
    end
  end

  test "twtlink attributes" do
    VCR.use_cassette('twt_attributes') do
      url = "http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/"
      assert_equal "The Internet Of Someone Else’s Things | TechCrunch", get_title(url)
      assert_match "The Internet Of Things is coming. Rejoice!", get_text(url)
      assert_equal 2, get_sentiment(url)
      assert_match "handwavey vaporware notion,smart things", get_tags(url)
      assert_equal "english", get_language(url)
      assert_equal "https://tctechcrunch2011.files.wordpress.com/2014/10/trojan-horse.jpg?w=738", get_image(url)
      assert_not a_video?(url)
    end
  end
end
