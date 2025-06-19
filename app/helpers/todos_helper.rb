module TodosHelper
  # todoを移動したときのflash のメッセージ
  MOVEMENT_MESSAGES = {
    today:    "今日に移動しました",
    upcoming: "近日予定に移動しました",
    archived: "アーカイブに移動しました。"
  }.freeze

  def build_toggle_done_stream(todo, source)
    if todo.due_at.to_date >= Date.current  # 今日以降 かつ done がtrueになったとき
      if todo.done?
        move(todo, :archived, MOVEMENT_MESSAGES[:archived], source)
      else
        toggle_done_in_archive(todo, source)
      end
    elsif todo.due_at.to_date < Date.current
      nil
    end
  end

  # todo 作成時に発動する Turbo stream
  def build_create_todo_stream(todo, source)
    streams = []
    streams.concat(insert_new_todo_to_list(todo, source))
    streams.concat(Array(move_todo_stream(todo, source)))
    streams.reduce(:+)
  end

  # todo 編集時に発動する Turbo steam
  def build_update_todo_stream(todo, source)
    streams = []
    streams.concat(Array(move_todo_stream(todo, source)))
    streams.reduce(:+)
  end

  # todo 削除時に発動する Turbo stream
  def delete_todo(todo)
    flash.now[:notice] = "todoを削除しました"
    turbo_stream.remove(dom_id(todo)) +
    turbo_stream.replace("flash", partial: "shared/flash")
  end

  private

    # add_todo_buttonに入った新規todo を todos_source に移動する
    def insert_new_todo_to_list(todo, source)
      [
        turbo_stream.append("todos_#{source}", partial: "todos/todo", locals: { todo: todo, source: source }),
        turbo_stream.replace("add_todo_button_#{source}", partial: "lists/add_todo_button", locals: { source: source })
      ]
    end

    # todo作成、編集の両方で使用
    def move_todo_stream(todo, source)
      # 過去日ならdone をtrue としておく
      if todo.due_at.to_date < Date.current && !todo.done?
        todo.update(done: true)
      end
      # 期限日と done による行き先の決定
      target_list = case todo.due_at.to_date <=> Date.current
      when  1 then  :upcoming   # due_at > today
      when -1 then  :archived   # due_at < today
      else          :today   # due_at == today
      end
      # sourceと同じor doneがtrue なら要素置換、違えば移動
      if source.to_s == target_list.to_s || todo.done
        puts ">>> sourceと同じor doneがtrue"
        replace_todo(todo, source)
      else
        puts ">>> todo を移動"
        message = MOVEMENT_MESSAGES[target_list]
        move(todo, target_list, message, source)
      end
    end
    # list は移動先、notice はflash の文章,source は現在の画面
    def move(todo, list, notice, source)
      flash.now[:notice] = notice
      # 指定されたlist内で todoと同じ日のtodos をsource_todos とする
      source_todos = current_user.todos.send(source).where(due_at: todo.due_at.all_day)
      streams = [
        turbo_stream.remove(dom_id(todo)),
        turbo_stream.prepend("todos_#{list}", render(partial: "todos/todo", locals: { todo: todo, source: list.to_s })),
        turbo_stream.replace("flash", partial: "shared/flash")
      ]

      if source_todos.empty?
        group_id = "todos_group_#{todo.due_at.to_date}"
        streams << turbo_stream.remove(group_id)
      end
      streams.reduce(:+)
    end

    def replace_todo(todo, source)
      source_todos =  current_user.todos.send(source).where(due_at: todo.due_at.all_day)
      # 初めてのtodo作成の場合
      if source_todos.count == 1 && todo.saved_change_to_id?
        turbo_stream.append(
        "todos_list_wrapper",
        render(partial: "lists/todos_list", locals: { todos: source_todos, source: source })
      )
      else
        turbo_stream.update(
        dom_id(todo),
        render(partial: "todos/todo", locals: { todo: todo, source: source })
      )
      end
    end

    def toggle_done_in_archive(todo, source)
      notice = (todo.due_at.to_date == Time.zone.now.to_date) ? "今日に移動しました" : "近日予定に移動しました"
      list = (todo.due_at.to_date == Time.zone.now.to_date) ? :today : :upcoming
      move(todo, list, notice, source)
    end
end
