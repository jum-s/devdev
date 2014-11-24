require 'test_helper'

class AutopostTest < ActiveSupport::TestCase

  test "have a valid factory" do
    assert FactoryGirl.build(:autopost).valid?
  end

  test "feed" do
    VCR.use_cassette('get_feed') do
      autopost = FactoryGirl.build(:autopost)
      autopost.clean_url("http://www.youtube.com/watch?v=gkSActeh1S8&feature=youtu.be")
      assert_equal "http://www.youtube.com/watch?v=gkSActeh1S8&feature=youtu.be", autopost.url
      autopost.clean_url("http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/")
      assert_equal "http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/", autopost.url
    end
  end
end