require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
  end
end

class UsersLoginTest < UsersLogin

  test 'should not login with invalid email' do
    post user_session_path, params: { user: { email: '',
                                              password: 'password'} } 
    assert_not flash.empty?
    assert_match 'メールアドレス もしくはパスワードが不正です。', response.body
  end

  test 'should not login with invalid password' do
    post user_session_path, params: { user: { email: @user.email,
                                              password: ''} } 
    assert_not flash.empty?
    assert_match 'メールアドレス もしくはパスワードが不正です。', response.body
  end

  test 'should login with valid information' do
    post user_session_path, params: { user: { email: @user.email, password: 'password' } }
    assert_response :see_other
    follow_redirect! 
    assert_not flash.empty?
    assert_template 'lists/today'
  end

end


# ---TODO: ログアウトのテストをログアウトボタン実装したらここに記述する----