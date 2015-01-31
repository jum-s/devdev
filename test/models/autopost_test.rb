require 'test_helper'

class AutopostTest < ActiveSupport::TestCase
  include ApplicationHelper 
  include ApiHelper 

  test "create new autopost" do
      auto = FactoryGirl.create(:autopost)
      new_url = auto.new_urls.first

      assert_not Autopost.all.map(&:url).include?(new_url)
      autopost.create_autoposts
      assert_includes Autopost.all.map(&:url), new_url
  end
end