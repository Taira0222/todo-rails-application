require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    get signup_path
  end
end


class UsersSignupTest < UsersSignup
  test 'invalid signup infomation' do
    assert_no_difference 'User.count' do
      post user_registration_path, params: {user: {name: '',
                                                   email: '',
                                                   password: 'foo',
                                                   password_confirmation: 'bar'} }
    end
    assert_response :unprocessable_entity
    assert_select 'div#error_explanation'
  end

  test 'valid signup information' do
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', new_user_confirmation_path
    ActionMailer::Base.deliveries.clear
    assert_difference 'User.count',1 do
      post user_registration_path, params: {user: {name: 'test',
                                                   email: 'test@gmail.com',
                                                   password: 'foobar',
                                                   password_confirmation: 'foobar'} }
    end
    # メール送信した画面に遷移
    assert_redirected_to confirmation_sent_path

    # メールが1件送られていること
    assert_equal 1, ActionMailer::Base.deliveries.size

    # 送信したメールのテスト
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["test@gmail.com"], mail.to
    assert_match "【重要】アカウントの有効化について", mail.subject


  end
end