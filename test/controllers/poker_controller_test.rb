require 'test_helper'

class PokerControllerTest < ActionDispatch::IntegrationTest
  test "should get check_form" do
    get poker_check_form_url
    assert_response :success
  end

end
