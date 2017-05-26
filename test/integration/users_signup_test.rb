require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'layout' do
    get signup_path
    assert_template 'users/new'
    assert_select 'form[action=?]', signup_path
  end

  test 'invalid' do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: {user: {name: '', email: 's', password: 'o',
                                                  password_confirmation: 's'}}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation > ul > li', count: 4

  end

  test 'valid' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {user:{name:'jiro', email: 'ramen@jiro.com',
                                        password:'foobar',
                                        password_confirmation:'foobar'}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
