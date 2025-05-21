require "test_helper"

class DisplayTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:user1)
  end

  test 'guest header and footer display' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count:3
    assert_select 'a[href=?]', 'https://github.com/Taira0222', count:3
    assert_select 'a[href=?]', 'https://qiita.com/Taira0222', count:2
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', login_path, count:2
  end

  test 'login header display' do
    sign_in @user
    get today_path
    assert_select 'a[href=?]', today_path, count:2 
    assert_select 'a[href=?]', upcoming_path
    assert_select 'a[href=?]', inbox_path
    assert_match @user.name, response.body
    assert_match 'アカウント情報', response.body
    assert_match 'ログアウト', response.body
    assert_match 'アカウント削除', response.body
  end
end
