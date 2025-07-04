require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user should have many todos and valid dependent" do
    # user2 はtodo を所有していない
    user = users(:user2)
    title1 = "Todo 1"
    title2 = "Todo 2"
    todo1 = todo_create(user, title1)
    todo2 = todo_create(user, title2)
    # has_manyの確認
    assert_equal 2, user.todos.count
    assert_includes user.todos, todo1
    assert_includes user.todos, todo2
    # dependentの確認
    user.destroy
    assert_nil Todo.find_by(id: todo1.id)
    assert_nil Todo.find_by(id: todo2.id)
  end

  test "should be invalid with name " do
    user = User.new(name: "",
                    email: "test@example.com",
                    password: "password",
                    password_confirmation: "password")
    assert_not user.valid?
  end

  test "should be valid with name" do
    user = User.new(name: "Takeshi",
                    email: "test@example.com",
                    password: "password",
                    password_confirmation: "password")
    assert user.valid?
  end

  test "should be invalid with 31 charactors" do
    name = "a"*31
    user = User.new(name: name,
                    email: "test@example.com",
                    password: "password",
                    password_confirmation: "password")
    assert_not user.valid?
  end

  test "should be valid within 30 charactors" do
    name = "a"*30
    user = User.new(name: name,
                    email: "test@example.com",
                    password: "password",
                    password_confirmation: "password")
    assert user.valid?
  end
end
