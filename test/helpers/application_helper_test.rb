require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @twtlink = FactoryGirl.create(:twtlink, text: "lorem ipsum", title: "foo", word_count: "2000")
  end

  test "should display time read" do
    assert_equal display_reading_time(@twtlink), "12 min"
  end
end
