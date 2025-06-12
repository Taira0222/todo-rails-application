require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:user1)
  end
end

class UsersLoginTest < UsersLogin
  test "should not login with invalid email" do
    post user_session_path, params: { user: { email: "",
                                              password: "password" } }
    assert_not flash.empty?
    assert_match "メールアドレス もしくはパスワードが不正です。", response.body
  end

  test "should not login with invalid password" do
    post user_session_path, params: { user: { email: @user.email,
                                              password: "" } }
    assert_not flash.empty?
    assert_match "メールアドレス もしくはパスワードが不正です。", response.body
  end

  test "should login with valid information" do
    post user_session_path, params: { user: { email: @user.email, password: "password" } }
    assert_response :see_other
    follow_redirect!
    assert_not flash.empty?
    assert_template "lists/today"
  end
end


class UsersLogoutTest < UsersLogin
  test "logout valid user" do
    # ログイン処理
    sign_in @user
    get today_path
    # ログアウト処理
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash.empty?
    assert_template "static_pages/home"
  end
end
