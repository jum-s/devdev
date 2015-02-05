require 'test_helper'

class TwtlinksControllerTest < ActionController::TestCase
  include LanguageHelper

  test "should get index" do
    FactoryGirl.create(:twtlink, url: "http://www.youtube.com", title: "foo")
    get :index, :locale => 'en'
    assert_response :success
  end
end
