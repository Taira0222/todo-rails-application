require "test_helper"

class UserDeleteTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:user1)
  end

  test 'guest cannot delete account' do
    assert_no_difference 'User.count' do
      delete user_registration_path
    end    
    assert_redirected_to new_user_session_path
    assert_match /アカウント登録もしくはログインしてください。/, flash[:alert]
  end

  test 'user can delete own account' do
    sign_in @user
    assert_difference 'User.count',-1 do
      delete user_registration_path
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_match  /アカウントを削除しました。またのご利用をお待ちしております。/, flash[:notice]
    assert_nil controller.current_user  
  end

  test 'deleted user cannot sign in' do
    sign_in @user
    assert_difference 'User.count',-1 do
      delete user_registration_path
    end
    follow_redirect!
    post user_session_path, params: { user: { email: @user.email, 
                                              password: 'password' } }
    assert_match /メールアドレス もしくはパスワードが不正です。/, flash[:alert]
  end
  
end
