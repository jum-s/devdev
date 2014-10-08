require 'test_helper'

class TwtlinksControllerTest < ActionController::TestCase
  test "should get index" do
    @twtlinks = FactoryGirl.create(:twtlink, url: "http://www.youtube.com")
    get :index, :locale => 'en'
    assert_response :success
  end
end
