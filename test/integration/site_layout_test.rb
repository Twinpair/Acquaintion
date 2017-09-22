require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout links with no user" do
    get root_path
    assert_template '/'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
  end

  test "layout links with logged in user" do
    user = users(:eric)
    log_in_as(user)
    get root_path
    assert_template '/'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(user)
    assert_select "a[href=?]", logout_path
  end

end
