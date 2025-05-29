module TodosHelper

  # doneボタンを押したときに発動する Turbo stream
  def done_toggle_stream(todo, source)
    # source に today か upcoming が含まれている場合
    
    if %w[today upcoming].include?(source) && todo.done?
      flash[:notice] = 'アーカイブに移動しました。'

      return turbo_stream.remove(dom_id(todo)) + # +を書かないとremoveの処理だけしか行われない
            turbo_stream.prepend(
              'todos_archived',
              render(partial: 'todos/todo', locals: { todo: todo, source: 'archived' })
            ) +
            turbo_stream.replace("flash", partial: "shared/flash")
      
    # source に archived が含まれている場合
    elsif source == 'archived' && !todo.done?
      return if todo.due_at.to_date < Date.current # 過去ならdoneボタンを押しても何も起こらないように設定。
      target = todo.due_at.to_date > Date.current ? 'upcoming' : 'today'
      flash[:notice] = (target == 'today') ? "今日に移動しました" : "近日予定に移動しました"      

      return turbo_stream.remove(dom_id(todo)) + # +を書かないとremoveの処理だけしか行われない
            turbo_stream.prepend(
              "todos_#{target}",
              render(partial: 'todos/todo', locals: { todo: todo, source: target })
            )+
            turbo_stream.replace("flash", partial: "shared/flash")
    end
  end

  # todo 作成時・編集時に発動する Turbo stream
  def default_update_stream(todo, source)
    turbo_stream.replace(
      dom_id(todo),
      render(partial: 'todos/todo', locals: { todo: todo, source: source })
    )
  end

end
