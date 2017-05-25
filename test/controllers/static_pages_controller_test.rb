require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = 'Ruby on Rails Tutorial Sample App'
  end

  test 'should get home' do
    get root_url
    assert_response :success
    assert_select 'title', full_title('home')
  end

  test 'should get help' do
    get help_url
    assert_response :success
    assert_select 'title', full_title('help')
  end

  test 'should get contact' do
    get contact_url
    assert_response :success
    assert_select 'title', full_title('contact')
  end

  test 'should get about' do
    get about_url
    assert_response :success
    assert_select 'title', full_title('about')
  end
end
