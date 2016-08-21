require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get users/new" do
    get :new
    assert_response :success
  end

end
