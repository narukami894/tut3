require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'invalid' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', email: '', password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div#error_explanation > ul > li', count: 5
  end

  test 'valid' do
    get edit_user_path(@user)
    assert_equal edit_user_url(@user), session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    delete logout_path(@user)
    assert_nil session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to user_path(@user)
    patch user_path(@user), params: { user: { name: 'name', email: 'foo@bar.com' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal 'name', @user.name
    assert_equal 'foo@bar.com', @user.email
  end
end
