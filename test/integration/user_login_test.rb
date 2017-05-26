require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
    # @user = users(:michael)
    @user = users(:michael)
    get login_path
  end

  test 'invalid login' do
    post login_path, params: { session: { email: 'hoge', password: 'piyo' } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.nil?
    assert_nil session[:user_id]
  end

  test 'valid login' do
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_equal @user.id, session[:user_id]
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', logout_path
    delete logout_path
    assert_not is_logged_in?
    assert_nil session[:user_id]
    assert_redirected_to root_path
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
    assert_select 'a[href=?]', logout_path, count: 0
  end

  test 'remember me' do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies[:user_id]
    assert_nil cookies['remember_token']
    delete logout_path
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
    delete logout_path
    assert_nil cookies[:user_id]
    # assert_nil cookies['remember_token']
  end
end
