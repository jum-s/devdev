require 'test_helper'

class MoisControllerTest < ActionController::TestCase
  test "should get cv" do
    get :cv
    assert_response :success
  end

  test "should get realisation" do
    get :realisation
    assert_response :success
  end

end
