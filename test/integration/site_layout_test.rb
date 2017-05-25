require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'site layout' do
    get root_path
    assert_template 'staticpages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', help_path
    get signup_path
    assert_template 'users/new'
    assert_select 'title', full_title('Sign up')
  end
end