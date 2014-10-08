require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    @pensee_random = FactoryGirl.create(:pensee, text: "foo, bar")
    get :index
    assert_response :success
  end

end
