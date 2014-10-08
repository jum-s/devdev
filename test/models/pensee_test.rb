require 'test_helper'

class PenseeTest < ActiveSupport::TestCase
  test "have a valid factory" do
    assert FactoryGirl.build(:pensee).valid?
  end

end
