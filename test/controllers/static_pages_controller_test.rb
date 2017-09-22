require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  test "should get home" do
    get "/"
    assert_response :success
    assert_select "title", "Acquaintion"
  end

end
