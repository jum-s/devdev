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

  test "get attribute" do
    VCR.use_cassette('get_twt_attr') do
      twtlink = FactoryGirl.build(:twtlink)
      url = "http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/"
      assert_equal "The Internet Of Someone Else’s Things | TechCrunch", twtlink.get_title(url)
      assert_match "The Internet Of Things is coming. Rejoice!" , twtlink.get_text(url)
      assert_equal 2, twtlink.get_sentiment(url)
      assert_match "handwavey vaporware notion,smart things", twtlink.get_tags(url)
      assert_not twtlink.has_a_video(url)
    end
  end

  test "create twtlink" do
    VCR.use_cassette('create_twtlink') do
      twtlink = FactoryGirl.build(:twtlink)
      twtlink.create_twtlinks
      assert_equal "Tanzania: Marriages of convenience | Mail & Guardian (Mobile edition)", Twtlink.offset(1).last.title
      assert_equal 2, Twtlink.offset(1).last.sentiment
      assert_equal "http://cdn.mg.co.za/crop/content/images/2014/11/13/tanzania13_square.jpg/300x300/", Twtlink.offset(1).last.image
      assert_equal 849, Twtlink.offset(1).last.word_count
      assert_match " A younger woman is making some ",  Twtlink.offset(1).last.text
      assert_match "children,women,nyumba ntobhu", Twtlink.offset(1).last.tag
      assert_equal "english", Twtlink.offset(1).last.language
    end
  end

end
