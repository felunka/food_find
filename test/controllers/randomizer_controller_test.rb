require 'test_helper'

class RandomizerControllerTest < ActionDispatch::IntegrationTest
  test "should get get" do
    get randomizer_get_url
    assert_response :success
  end

end
