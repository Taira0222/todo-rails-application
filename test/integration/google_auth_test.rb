require "test_helper"

class GoogleAuthTest < ActionDispatch::IntegrationTest

  test 'valid infomation google auth' do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '1234567890',
    info: {
      name:  'test_user',
      email: 'test@example.com'
    }
  })
    assert_difference "User.count",1 do
      get user_google_oauth2_omniauth_callback_path
      follow_redirect! # userのパスにリダイレクト
      follow_redirect! #today_pathへリダイレクト
    end
    assert_equal I18n.t('devise.omniauth_callbacks.success', kind: 'Google'), flash[:notice]
    assert_template 'lists/today'
    assert_match    'test_user', response.body
    assert User.exists?(email: 'test@example.com')
  end

  # else の google 認証は成功したがuser が保存できなかった場合のテスト(会員登録画面からの操作)
  test 'success google authorization but failed save user from signup page' do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '1111',
      info:{ 
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

  # else の google 認証は成功したがuser が保存できなかった場合のテスト(ログイン画面からの操作)
  test 'success google authorization but failed save user from login page' do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '1111',
      info:{ 
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

  test 'fail google OAuth from signup page' do
    mock_google_oauth(:invalid_credentials)
    assert_no_difference "User.count" do
      get user_google_oauth2_omniauth_callback_path,
          headers: { "HTTP_REFERER" => signup_url }
    end
    assert_redirected_to signup_url
  end

  test 'fail google OAuth from login page' do
    mock_google_oauth(:invalid_credentials)
    assert_no_difference "User.count" do
      get user_google_oauth2_omniauth_callback_path,
          headers: { "HTTP_REFERER" => login_url }
    end
    assert_redirected_to login_url
  end

end
