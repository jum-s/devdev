require 'test_helper'

class TwtlinkTest < ActiveSupport::TestCase
  include ApplicationHelper 

  test "have a valid factory" do
    assert FactoryGirl.build(:twtlink).valid?
  end

  test "jumijums twitter connect API" do
    VCR.use_cassette('twitter_connect') do
      twtlink = FactoryGirl.build(:twtlink)
      assert_equal 1721885928, JSON.parse(twtlink.twitter_connect.body).first["user"]["id"]
    end
  end

  test "fetch new urls" do
    VCR.use_cassette('new_twt_urls') do
      twtlink = FactoryGirl.build(:twtlink)
      assert twtlink.new_urls.first.include? "http"
      old_urls = Twtlink.all.map(&:url)
      assert_not old_urls.include? twtlink.new_urls.first
    end
  end
end
