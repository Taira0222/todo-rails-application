require "test_helper"

class LoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    get login_path
  end

  # 状態遷移表を参照(doc/state_digram_table/login_test.md)

  # ログイン画面 →(誤入力)→ログイン失敗
  test "should not login with invalid information when you are in login form" do
    fail_login
    assert_not flash.empty?
    assert_match "メールアドレス もしくはパスワードが不正です。", response.body
  end

  # ログイン画面 →(正しい情報(remember_me on))→ログイン成功（クッキー）
  test "should login with valid information and remember me is on " do
    log_in_as(@user)
    assert_response :see_other
    follow_redirect!
    assert_not flash.empty?
    assert_template "lists/today"
    assert_not cookies["remember_user_token"].blank?
  end

  # ログイン失敗画面 →(正しい情報(remember_me on))→ログイン成功（クッキー）
  test "should login with valid information and remember me is on from failed status " do
    # 初期状態→(誤った情報)→ ログイン失敗
    fail_login
    # 正しい情報(remember_me on)でログイン
    log_in_as(@user)
    assert_response :see_other
    follow_redirect!
    assert_not flash.empty?
    assert_template "lists/today"
    assert_not cookies["remember_user_token"].blank?
  end

  # ログイン画面 →(正しい情報(remember_me on))→ログイン成功（セッション）
  test "should login with valid information and remember me is off " do
    log_in_as(@user, remember_me: "0")
    assert_response :see_other
    follow_redirect!
    assert_not flash.empty?
    assert_template "lists/today"
    assert cookies["remember_user_token"].blank?
  end

  # ログイン失敗画面 →(正しい情報(remember_me off))→ログイン成功（クッキー）
  test "should login with valid information and remember me is off from failed status " do
    # ログイン画面→(誤った情報)→ ログイン失敗
    fail_login
    # 正しい情報(remember_me on)でログイン
    log_in_as(@user, remember_me: "0")
    assert_response :see_other
    follow_redirect!
    assert_not flash.empty?
    assert_template "lists/today"
    assert cookies["remember_user_token"].blank?
  end
end


# class UsersLogoutTest < UsersLogin
#   test "logout valid user" do
#     # ログイン処理
#     sign_in @user
#     get today_path
#     # ログアウト処理
#     delete logout_path
#     assert_redirected_to root_path
#     follow_redirect!
#     assert_not flash.empty?
#     assert_template "static_pages/home"
#   end
# end
