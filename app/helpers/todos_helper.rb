module TodosHelper
  def build_toggle_done_stream(todo)
    if todo.due_at.to_date >= Date.current  # 今日以降 かつ done がtrueになったとき
      if todo.done? # doneはチェック前の状態
        move(todo, :archived, "アーカイブに移動しました。")
      else
        toggle_done_in_archive(todo)
      end
    elsif todo.due_at.to_date < Date.current
      nil
    end
  end

  # todo 作成時に発動する Turbo stream
  def build_create_todo_stream(todo, source)
    streams = []
    streams.concat(insert_new_todo_to_list(todo, source))
    streams.concat(Array(move_todo_by_source_and_due_date(todo, source)))
    streams.reduce(:+)
  end

  # todo 編集時に発動する Turbo steam
  def build_update_todo_stream(todo, source)
    streams = []
    streams.concat(Array(move_todo_by_source_and_due_date(todo, source)))
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

    # todoのsource と 日付で処理を分岐
    def move_todo_by_source_and_due_date(todo, source)
      if todo.due_at.to_date > Date.current
        source == "upcoming" ? replace_todo(todo, source) : move(todo, :upcoming,  "近日予定に移動しました")
      elsif todo.due_at < Date.current
        todo.update(done: true)
        move(todo, :archived, "アーカイブに移動しました。")
      else
        source == "today" ? replace_todo(todo, source) : move(todo, :today, "今日に移動しました")
      end
    end

    def move(todo, list, notice)
      flash.now[:notice] = notice
      turbo_stream.remove(dom_id(todo)) +
      turbo_stream.prepend("todos_#{list}", render(partial: "todos/todo", locals: { todo: todo, source: list.to_s })) +
      turbo_stream.replace("flash", partial: "shared/flash")
    end

    def replace_todo(todo, source)
      turbo_stream.replace(
        dom_id(todo),
        render(partial: "todos/todo", locals: { todo: todo, source: source })
      )
    end

    def toggle_done_in_archive(todo)
      notice = (todo.due_at.to_date == Date.current) ? "今日に移動しました" : "近日予定に移動しました"
      list = (todo.due_at.to_date == Date.current) ? :today : :upcoming
      move(todo, list, notice)
    end
end
