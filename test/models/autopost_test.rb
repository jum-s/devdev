require 'test_helper'

class AutopostTest < ActiveSupport::TestCase
  include ApiHelper 
  include AttributeHelper

  test "create autopost from url " do
    VCR.use_cassette('create autopost from last framabag url') do
      url = "http://www.mobilemoneyasia.org/2015/01/is-it-ok-to-make-profit-serving-extreme.html"

      assert_not Autopost.all.map(&:url).include?(url)

      Autopost.new.create_with_url(url)
      assert_equal url, Autopost.last.url
      assert_equal get_title(url), Autopost.last.title
    end
  end
  
  test "framabag entries" do
    feeds = Feedjira::Feed.fetch_and_parse('https://www.framabag.org/u/jumijums/?feed&type=home&user_id=1&token=' + ENV['SECRET_KEY'], {:ssl_verify_peer => false}).entries
    assert feeds.count > 1
  end
end