require "test_helper"

class GoogleAuthTest < ActionDispatch::IntegrationTest
  # google認証 true & user.persist? true
  test "valid infomation google auth" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: "google_oauth2",
    uid: "1234567890",
    info: {
      name:  "test_user",
      email: "test@example.com"
    }
  })
    assert_difference "User.count", 1 do
      get user_google_oauth2_omniauth_callback_path
      follow_redirect! # userのパスにリダイレクト
      follow_redirect! # today_pathへリダイレクト
    end
    assert_equal I18n.t("devise.omniauth_callbacks.success", kind: "Google"), flash[:notice]
    assert_template "lists/today"
    assert_match    "test_user", response.body
    assert User.exists?(email: "test@example.com")
  end

  # google認証 true & user.persist? false (http_reffer = signup)
  test "success google authorization but failed save user from signup page" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: "1111",
      info: {
        name: nil,
        email: nil
      }
    })
    assert_no_difference "User.count" do
      get user_google_oauth2_omniauth_callback_path,
          headers: { "HTTP_REFERER" => signup_url }
    end
    assert_redirected_to signup_url
    assert_match "メールアドレスを入力してください\n名前を入力してください", flash[:alert]
  end

  # google認証 true & user.persist? false (http_reffer = signup)
  test "success google authorization but failed save user from login page" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: "1111",
      info: {
        name: nil,
        email: nil
      }
    })
    assert_no_difference "User.count" do
      get user_google_oauth2_omniauth_callback_path,
          headers: { "HTTP_REFERER" => login_url }
    end
    assert_redirected_to login_url
    assert_match "メールアドレスを入力してください\n名前を入力してください", flash[:alert]
  end

  # google認証 true & user.persist? false (http_reffer 指定なし)
  test "success google authorization but failed save user " do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: "1111",
      info: {
        name: nil,
        email: nil
      }
    })
    assert_no_difference "User.count" do
      get user_google_oauth2_omniauth_callback_path
    end
    assert_redirected_to new_user_registration_url
    assert_match "メールアドレスを入力してください\n名前を入力してください", flash[:alert]
  end

  # google認証 false & (http_reffer = signup)
  test "fail google OAuth from signup page" do
    mock_google_oauth(:invalid_credentials)
    assert_no_difference "User.count" do
      get user_google_oauth2_omniauth_callback_path,
          headers: { "HTTP_REFERER" => signup_url }
    end
    assert_redirected_to signup_url
  end

  # google認証 false & (http_reffer = login)
  test "fail google OAuth from login page" do
    mock_google_oauth(:invalid_credentials)
    assert_no_difference "User.count" do
      get user_google_oauth2_omniauth_callback_path,
          headers: { "HTTP_REFERER" => login_url }
    end
    assert_redirected_to login_url
  end

  # google認証 false & (http_reffer 指定なし)
  test "fail google OAuth " do
    mock_google_oauth(:invalid_credentials)
    assert_no_difference "User.count" do
      get user_google_oauth2_omniauth_callback_path
    end
    assert_redirected_to new_user_session_url
  end
end
