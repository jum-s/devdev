require 'test_helper'

class MoisControllerTest < ActionController::TestCase
  test "should get cv" do
    get :cv, :locale => 'en'
    assert_response :success
  end

  test "should get realisation" do
    get :realisation, :locale => 'en'
    assert_response :success
  end

end
