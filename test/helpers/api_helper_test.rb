class ApiHelperTest < ActionView::TestCase
  test "twitter connect" do
    VCR.use_cassette('api_helper') do
      assert_equal twitter_connect.content_type, "application/json"
    end
  end
end
