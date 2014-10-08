require 'test_helper'

class TwtlinkTest < ActiveSupport::TestCase
  test "have a valid factory" do
    assert FactoryGirl.build(:twtlink).valid?
  end

end
