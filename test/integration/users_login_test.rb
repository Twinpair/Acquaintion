require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
	def setup
    @user = users(:eric)
  end

  test "login with invalid information" do
    get login_path
    assert_template :new
    post login_path, params = { session: { email: "", password: "" } }
    assert_template :new
    assert_not flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params =  { session: { email: @user.email, password: "password" } }
    follow_redirect!
    assert_response :success
    assert_template '/'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

end
