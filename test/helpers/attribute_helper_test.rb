class AttributeHelperTest < ActionView::TestCase
  test "attributes fetch" do
    VCR.use_cassette('attributes') do
      url = "http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/"
      auto = FactoryGirl.build(:autopost, url: url)
      get_attr(auto, url)

      assert_equal "The Internet Of Someone Else’s Things | TechCrunch", auto.title
      # assert_match "The Internet Of Things is ", get_text(url)
      # assert_equal 2, get_sentiment(url)
      # assert_match "handwavey vaporware notion,smart things", get_tags(url)
      # assert_equal "english", get_language(url)
      # assert_equal "https://tctechcrunch2011.files.wordpress.com/2014/10/trojan-horse.jpg?w=738", get_image(url)
      # assert_not a_video?(url)
    end
  end
end