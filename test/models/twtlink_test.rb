require 'test_helper'

class TwtlinkTest < ActiveSupport::TestCase
  include ApplicationHelper 
  include AttributeHelper 

  test "have a valid factory" do
    assert FactoryGirl.build(:twtlink).valid?
  end

  test "jumijums twitter connect API" do
    VCR.use_cassette('twitter_connect') do
      twtlink = FactoryGirl.build(:twtlink)
      assert_equal 1721885928, JSON.parse(twtlink.twitter_connect.body).first["user"]["id"]
    end
  end

  test "create twtlinks" do
    VCR.use_cassette('new_twt_urls') do
      twtlink = FactoryGirl.build(:twtlink)
      new_url = twtlink.new_urls.last
      assert_not Twtlink.all.map(&:url).include?(new_url)
      Twtlink.new.create([new_url])
      assert_equal Twtlink.last.title, get_title(new_url) 
    end
  end
end
