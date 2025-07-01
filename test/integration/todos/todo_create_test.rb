require "test_helper"

class TodoCreate < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)

    @today_todo = todos(:today)
    @upcoming_todo = todos(:upcoming)
    @archived_todo = todos(:archived)
  end

  # todo作成画面にturbo-stream を呼び出して遷移
  def move_to_todo_create_page(source)
    get new_todo_path,
          params: { source: source },
          headers: {
            "X-Requested-With" => "XMLHttpRequest"
          }
  end

  # キャンセルボタンを押して、初期画面に遷移
  def move_to_initial_page_with_cancel(source)
    get public_send("#{source}_path"),
          params: { source: source },
          headers: {
            "X-Requested-With" => "XMLHttpRequest"
          }
  end
end

# doc/state_diagram_table/todos/todo_create_test.md を参照
class TodoStateDiagramCreateTest < TodoCreate
  def setup
    super
    log_in_as(@user)
    # archived からtodoを追加するボタンは設置していないから排除
    @sources = [
      "today",
      "upcoming"
    ]
    @target_lists =[
      :today,
      :upcoming,
      :archived
    ]
    @new_request_token = SecureRandom.uuid
  end

  test "success create todo when date name is equal to source" do
    @sources.each do |source|
      # 初期画面 → todo作成画面 遷移テスト
      move_to_todo_create_page(source)
      assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
      assert_turbo_stream action: "update", target: "flash"
      assert_turbo_stream action: "replace", target: "add_todo_button_#{source}" do
        assert_select "div#todo_#{source}_form"
      end

      @target_lists.each do |target_list|
        assert_difference "Todo.count", 1 do
          # today, upcoming, archived(過去)にtodo をそれぞれ設定
          todo = instance_variable_get("@#{target_list}_todo")
           post todos_path,
            params: { source: source,
                    request_token: @new_request_token,
                    todo: { title: todo.title,
                            description: todo.description,
                            due_date: todo.due_at.to_date,
                            has_time: false }
                    },
            headers: {
              "X-Requested-With" => "XMLHttpRequest"
            }
          # 新レコードを取得
          new_todo = @user.todos.order(:created_at).last

          assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type

          # relocate_add_buttonメソッドを確認
          assert_turbo_stream action: "replace", target: "todo_#{source}_form" do
            assert_select "div#add_todo_button_#{source}"
          end

          if target_list.to_s == source
            # 日付とsource が合致している場合
            assert_turbo_stream action: "update", target: "flash"
            assert_turbo_stream action: "append", target: "todos_#{source}"
          else
            # target_listに移動する場合
            assert_turbo_stream action: "update", target: "flash"
            assert_turbo_stream action: "remove", target: dom_id(new_todo)
            assert_turbo_stream action: "prepend", target: "todos_#{target_list}"
            # target_list → todo作成画面
            move_to_todo_create_page(target_list)
            assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
            assert_turbo_stream action: "update", target: "flash"
            assert_turbo_stream action: "replace", target: "add_todo_button_#{target_list}" do
              assert_select "div#todo_#{target_list}_form"
            end
          end
        end
      end
    end
  end



  # todo作成画面→初期画面
  test "click cancel button from todo new form to initial page" do
    @sources.each do |source|
      # todo作成画面へ移動
      move_to_todo_create_page(source)
      # todo作成画面 →初期画面
      move_to_initial_page_with_cancel(source)
      assert_equal "text/html; charset=utf-8", response.content_type
      assert_template "lists/#{source}"
    end
  end
end
