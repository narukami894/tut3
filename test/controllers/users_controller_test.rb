require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url
    assert_response :success
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get show" do
    get user_url
    assert_response :success
  end

end
