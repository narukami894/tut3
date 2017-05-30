require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'password', password_confirmation: 'password')
  end

  # valid
  test 'should be valid' do
    assert @user.valid?
  end

  test 'should be valid with correct format of email' do
    collect_emails_list = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                             first.last@foo.jp alice+bob@baz.cn]
    collect_emails_list.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test 'email should save in downcase' do
    upcase_email = 'HOGE@FUGA.PIYO'
    @user.email =  upcase_email
    @user.save
    assert_equal upcase_email.downcase, @user.reload.email
  end

  # invalid
  # name
  test 'should be invalid when name is empty' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'should be invalid when name is too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  # email
  test 'should be invalid with incorrect format of email' do
    incorrect_email_list = %w[user@example,com user_at_foo.org user.name@example.
                              foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    incorrect_email_list.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} shouldn't be valid"
    end
  end

  test 'should be invalid when email is empty' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'should be invalid when email is too long' do
    @user.email = "#{'a' * 244}@example.com"
    assert_not @user.valid?
  end

  test 'should be invalid when email is duplicate' do
    dup_user = @user.dup
    dup_user.email.upcase!
    @user.save
    assert_not dup_user.valid?
  end

  # password
  test 'should be invalid when password is empty' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'should be invalid when password is too short' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  # methods
  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'should follow and unfollow a user' do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test 'feed should have the right posts' do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

  # dependent destroy
  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'hoge')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
