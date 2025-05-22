require "test_helper"

class EmailChangeTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user1)
    sign_in @user
    get account_edit_path
  end

  test 'should not update with invalid name' do
    patch user_registration_path, params: { user: {name: '',
                                               email:'@user.email'} }
    assert_select 'div#error_explanation'
    assert_match '名前を入力してください', response.body
  end

  test 'should not update with invalid email' do
    patch user_registration_path, params: { user: {name: @user.name,
                                               email:''} }
    assert_select 'div#error_explanation'
    assert_match 'メールアドレスを入力してください', response.body
  end

  test 'update information with valid name' do
    patch user_registration_path, params: { user: {name: 'goda',
                                               email:@user.email } }
    follow_redirect!                                           
    @user.reload
    assert_equal 'goda', @user.name
    assert_match @user.name, response.body
    assert_not flash.empty?
    
  end

  test 'update information with valid email' do
    ActionMailer::Base.deliveries.clear
    patch user_registration_path, params: { user: {name: @user.name,
                                               email: 'goda@example.com' } }
    follow_redirect!
    assert_not flash.empty?
    assert_equal 2, ActionMailer::Base.deliveries.size
  end


end