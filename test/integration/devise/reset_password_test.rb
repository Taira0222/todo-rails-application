require "test_helper"

class ResetPasswordRequest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    get new_user_password_path
  end
end

class ResetPasswordRequestTest < ResetPasswordRequest
  test "reset password with empty email" do
    post user_password_path, params: { user: { email: "" } }
    assert_select "div#error_explanation", /メールアドレスを入力してください/
    assert_template "devise/passwords/new"
  end

  test "password reset with invalid information " do
    post user_password_path, params: { user: { email: "invalid@gmail.com" } }
    assert_select "div#error_explanation", /メールアドレスは見つかりませんでした。/
    assert_template "devise/passwords/new"
  end

  test "password reset with valid information" do
    ActionMailer::Base.deliveries.clear # メールの件数をリセット
    post user_password_path, params: { user: { email: @user.email } }
    follow_redirect!
    assert_not flash.empty?
    # メールが1件送られていること
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end


class ResetPasswordUpdateTest < ActionDispatch::IntegrationTest
  include Devise::Controllers::UrlHelpers
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:user1)
    @raw_token = @user.send_reset_password_instructions # enc_tokenをDBに保存、返り値raw_token

    get edit_user_password_path(reset_password_token: @raw_token)
  end

  test "no-header and footer template" do
    assert_template "layouts/minimal"
  end

  test "empty password" do
    patch user_password_path, params: { user: { reset_password_token: @raw_token,
                                                password: "",
                                                password_confirmation: "" } }
    assert_select "div#error_explanation", /パスワードを入力してください/
    assert_template "layouts/minimal"
  end

  test "less than 6 charactors password" do
    patch user_password_path, params: { user: { reset_password_token: @raw_token,
                                                password: "test",
                                                password_confirmation: "test" } }
    assert_select "div#error_explanation", /パスワードは6文字以上で入力してください/
    assert_template "layouts/minimal"
  end

  test "different from password and password_confirmation" do
    patch user_password_path, params: { user: { reset_password_token: @raw_token,
                                                password: "password",
                                                password_confirmation: "test123" } }
    assert_select "div#error_explanation", /パスワード（確認用）とパスワードの入力が一致しません/
    assert_template "layouts/minimal"
  end

  test "success reset password" do
    old_digest = @user.encrypted_password
    patch user_password_path, params: { user: { reset_password_token: @raw_token,
                                                password: "passwordchange",
                                                password_confirmation: "passwordchange" } }
    follow_redirect!
    assert_not flash.empty?
    assert_template "sessions/new"
    assert_not_equal old_digest, @user.reload.encrypted_password
  end
end
