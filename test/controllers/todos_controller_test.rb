require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  def test_get_create
    get todos_create_url
    assert_response :success
  end

  def test_get_update
    get todos_update_url
    assert_response :success
  end

  def test_get_destroy
    get todos_destroy_url
    assert_response :success
  end
end
