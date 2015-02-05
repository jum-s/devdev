require 'test_helper'

class AutopostTest < ActiveSupport::TestCase
  include ApiHelper 
  include AttributeHelper

  test "create new autopost framabag url" do
    VCR.use_cassette('create autopost from last framabag url') do
      auto = FactoryGirl.create(:autopost)
      feeds = Feedjira::Feed.fetch_and_parse('https://www.framabag.org/u/jumijums/?feed&type=home&user_id=1&token=' + ENV['SECRET_KEY']).entries
      new_url = feeds.map(&:url).last

      assert_not Autopost.all.map(&:url).include?(new_url)
      Autopost.new.create_with_url(new_url)
      assert_equal Autopost.last.url, new_url
      assert_equal Autopost.last.title, get_title(new_url)
    end
  end
  
  # test "LONG TEST create new autoposts from framabag" do
  #   VCR.use_cassette('create autopost from framabag') do
  #     auto = FactoryGirl.create(:autopost)
  #     feeds = Feedjira::Feed.fetch_and_parse('https://www.framabag.org/u/jumijums/?feed&type=home&user_id=1&token=' + ENV['SECRET_KEY']).entries
  #     new_url = feeds.map(&:url).last

  #     assert_not Autopost.all.map(&:url).include?(new_url)
  #     Autopost.new.create_from_framabag_urls
  #     assert_equal Autopost.last.url, new_url
  #   end
  # end
end