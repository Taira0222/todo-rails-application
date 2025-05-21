require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:user1)
    sign_in @user
  end

  def test_get_today
    get today_path
    assert_response :success
  end

  def test_get_upcoming
    get upcoming_path
    assert_response :success
  end

  def test_get_inbox
    get inbox_path
    assert_response :success
  end
end
