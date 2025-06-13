require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "returns blue class for :notice" do
    assert_equal "bg-blue-100 text-blue-700 border-blue-300", flash_color_class(:notice)
  end

  test "returns green class for :success" do
    assert_equal "bg-green-100 text-green-700 border-green-300", flash_color_class(:success)
  end

  test "returns red class for :alert" do
    assert_equal "bg-red-100 text-red-700 border-red-300", flash_color_class(:alert)
  end

  test "returns red class for :error" do
    assert_equal "bg-red-100 text-red-700 border-red-300", flash_color_class(:error)
  end

  test "returns gray class for unknown type" do
    assert_equal "bg-gray-100 text-gray-700 border-gray-300", flash_color_class(:unknown)
  end
end
