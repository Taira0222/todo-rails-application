require "test_helper"

class Display < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
  end
end

class HomeDisplayTest < Display
  test "guest header and footer display" do
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", "https://github.com/Taira0222", count: 3
    assert_select "a[href=?]", "https://qiita.com/Taira0222", count: 2
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path, count: 2
  end

  test "login header display" do
    sign_in @user
    get today_path
    assert_select "a[href=?]", today_path, count: 2
    assert_select "a[href=?]", upcoming_path
    assert_select "a[href=?]", archived_path
    assert_match @user.name, response.body
    assert_match "アカウント情報", response.body
    assert_match "ログアウト", response.body
    assert_match "アカウント削除", response.body
  end
end

class LoginDisplayTest < Display
  # 状態遷移表を参照(doc/state_digram_table/login_test.md)
  # google の状態遷移テストは複雑なので省略
  def setup
    super
    get login_path
  end

  # 初期画面→(会員登録ボタンを押す)→ 会員登録画面
  test "should redirect to signup" do
    assert_select "a[href=?]", signup_path
    get signup_path
    assert_template "devise/registrations/new"
  end

  # ログイン失敗→(会員登録ボタンを押す)→ 会員登録画面
  test "should redirect to signup from failed login" do
    fail_login
    assert_select "a[href=?]", signup_path
    get signup_path
    assert_template "devise/registrations/new"
  end

  # 初期画面→(パスワード忘れボタンを押す)→ パスワード忘れ画面
  test "should redirect to fogot password form" do
    assert_select "a[href=?]", new_user_password_path
    get new_user_password_path
    assert_template "devise/passwords/new"
  end

  # ログイン失敗→(パスワード忘れボタンを押す)→ パスワード忘れ画面
  test "should redirect to fogot password form from failed login" do
    fail_login
    assert_select "a[href=?]", new_user_password_path
    get new_user_password_path
    assert_template "devise/passwords/new"
  end

  # 初期画面→(確認メールボタンを押す)→ 確認メール画面
  test "should redirect to confirm mail form" do
    assert_select "a[href=?]", new_user_confirmation_path
    get new_user_confirmation_path
    assert_template "devise/confirmations/new"
  end

  # ログイン失敗→(確認メールボタンを押す)→ 確認メール画面
  test "should redirect to confirm mail form from failed login" do
    fail_login
    assert_select "a[href=?]", new_user_confirmation_path
    get new_user_confirmation_path
    assert_template "devise/confirmations/new"
  end
end
