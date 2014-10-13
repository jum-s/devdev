require 'test_helper'

class TwtlinkTest < ActiveSupport::TestCase

  test "have a valid factory" do
    assert FactoryGirl.build(:twtlink).valid?
  end

  test "jumijums twitter connect API" do
    VCR.use_cassette('twitter_connect') do
      twtlink = FactoryGirl.build(:twtlink)
      tweet = JSON.parse(twtlink.twitter_connect.body)
      assert_equal twtlink.twitter_connect.code, "200"
      assert_equal 1721885928, tweet.first["user"]["id"]
    end
  end

  test "fetch new urls" do
    VCR.use_cassette('fetch_all_urls') do
      twtlink = FactoryGirl.build(:twtlink)
      assert_not twtlink.fetch_new_urls.include?("http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/")
    end
  end

  test "get url title" do
    VCR.use_cassette('url_title') do
      twtlink = FactoryGirl.build(:twtlink)
      twtlink.get_title
      assert_equal "The Internet Of Someone Else’s Things | TechCrunch", twtlink.title
    end
  end

  test "get image" do
    VCR.use_cassette('url_image') do
      twtlink = FactoryGirl.build(:twtlink)
      twtlink.get_image
      assert_equal "http://tctechcrunch2011.files.wordpress.com/2014/10/trojan-horse.jpg?w=738", twtlink.image
    end
  end

  test "get text" do
    VCR.use_cassette('get_text') do
      twtlink = FactoryGirl.build(:twtlink)
      twtlink.get_text
      assert twtlink.text.include?('The Internet Of Things is coming. Rejoice! …Mostly')
    end
  end

end
