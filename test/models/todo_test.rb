require "test_helper"

class TodoTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
  end

  test "todo should belong to user" do
    todo = Todo.new(title: "Belong to user",
                    user: @user)
    assert todo.valid?
  end

  test "50 charactors title" do
    title = "a" * 50
    todo = @user.todos.create(title: title)
    assert todo.valid?
  end

  test "51 charactors title" do
    title = "a" * 51
    todo = @user.todos.create(title: title)
    assert_not todo.valid?
  end

  test "Do not allow empty title" do
    title = ""
    todo = @user.todos.create(title: title)
    assert_not todo.valid?
  end

  test "140 charactors of description" do
    title = "test"
    description = "a" * 140
    todo = @user.todos.create(title: title,
                              description: description)
    assert todo.valid?
  end

  test "141 charactors of description" do
    title = "test"
    description = "a" * 141
    todo = @user.todos.create(title: title,
                              description: description)
    assert_not todo.valid?
  end

  test "should include today scope(decision table)" do
    today_todo = todos(:today)
    assert_includes Todo.today, today_todo
  end

  test "should include upcoming scope" do
    upcoming_todo = todos(:upcoming)
    assert_includes Todo.upcoming, upcoming_todo
  end

  test "should include done or past-todos" do
    done_todo = Todo.create(
      user: @user,
      title: "done",
      description: "done",
      done: true,
      due_at: Time.zone.tomorrow,
    )
    past_todo = Todo.create(
      user: @user,
      title: "yesterday",
      description: "yesterday",
      done: false,
      due_at: Time.zone.yesterday
    )
    assert_includes Todo.archived, done_todo
    assert_includes Todo.archived, past_todo
  end
end
