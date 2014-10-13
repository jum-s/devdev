require 'test_helper'

class TwtlinkTest < ActiveSupport::TestCase

  test "have a valid factory" do
    assert FactoryGirl.build(:twtlink).valid?
  end

  test "jumijums twitter connect API" do
    VCR.use_cassette('twitter_connect') do
      response = Twtlink.twitter_connect
      tweet = JSON.parse(response.body)
      assert_equal response.code, "200"
      assert_equal 1721885928, tweet.first["user"]["id"]
    end
  end

  test "fetch news urls" do
    VCR.use_cassette('fetch_all_urls') do
      assert_not Twtlink.fetch_new_urls.include?("http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/")
    end
  end

  test "clean news urls" do
    VCR.use_cassette('clean_urls') do
      cleaned_url = Twtlink.clean_urls(["http://ow.ly/CBhWO"])
      assert_equal cleaned_url, ["http://ow.ly/CBhWO"]
    end
  end
end
