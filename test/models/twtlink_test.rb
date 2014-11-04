require 'test_helper'

class TwtlinkTest < ActiveSupport::TestCase

  test "have a valid factory" do
    assert FactoryGirl.build(:twtlink).valid?
  end

  test "jumijums twitter connect API" do
    VCR.use_cassette('twitter_connect') do
      twtlink = FactoryGirl.build(:twtlink)
      assert twtlink.fetch_new_urls.include? "http" 
      assert_equal 1721885928, tweet.first["user"]["id"]
      assert_not twtlink.fetch_new_urls.include?("http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/")
    end
  end

  test "create twtlink" do
    VCR.use_cassette('create_twtlink') do
      twtlink = FactoryGirl.build(:twtlink)
      twtlink.create_with_url
      assert_equal "http://techcrunch.com/2014/10/11/the-internet-of-someone-elses-things/", Twtlink.offset(1).last.url 
      # assert_equal "The Internet Of Someone Else’s Things | TechCrunch", Twtlink.offset(1).last.title
      assert_equal 2, Twtlink.offset(1).last.sentiment
      # assert_equal "http://tctechcrunch2011.files.wordpress.com/2014/10/trojan-horse.jpg?w=738", Twtlink.offset(1).last.image
      # assert_equal 735, Twtlink.offset(1).last.word_count
      # assert_equal "4 min", Twtlink.offset(1).last.reading_time
      # assert Twtlink.offset(1).last.text.include?('The Internet Of Things is coming. Rejoice! …Mostly')
      assert_equal "forfait logement", Twtlink.offset(1).last.tag
      assert_equal "french", Twtlink.offset(1).last.language
    end
  end

end
