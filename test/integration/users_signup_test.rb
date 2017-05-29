require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'layout' do
    get signup_path
    assert_template 'users/new'
    assert_select 'form[action=?]', signup_path
  end

  test 'invalid' do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '', email: 's', password: 'o',
                                          password_confirmation: 's' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation > ul > li', count: 4
  end

  test 'valid' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'jiro', email: 'ramen@jiro.com',
                                          password: 'foobar',
                                          password_confirmation: 'foobar' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as user
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
