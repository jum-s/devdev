require 'test_helper'

class AutopostTest < ActiveSupport::TestCase
  include ApplicationHelper 
  include ApiHelper 

  test "have a valid factory" do
    assert FactoryGirl.build(:autopost).valid?
  end
  test "connect framabag" do
    VCR.use_cassette('connect framabag') do
      autopost = FactoryGirl.build(:autopost)
      assert_equal "http://www.e-agriculture.org/", autopost.framabag_connect.last
    end
  end

  test "get attributes" do
     VCR.use_cassette('get_aut_attributes') do
      autopost = FactoryGirl.build(:autopost)
      url = "http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/"
      assert_equal "The Internet Of Someone Else’s Things | TechCrunch", autopost.get_title(url)
      assert_match "The Internet Of Things is coming. Rejoice!" , autopost.get_text(url)
      assert_equal 2, autopost.get_sentiment(url)
      assert_match "handwavey vaporware notion,smart things", autopost.get_tags(url)
      assert_not autopost.has_a_video(url)
    end
  end

  test "create autoposts" do
     VCR.use_cassette('create_autoposts') do
      autopost = FactoryGirl.create(:autopost)
      autopost.create_autoposts
      assert_response :success
    end
  end
end