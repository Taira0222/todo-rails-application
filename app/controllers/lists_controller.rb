class ListsController < ApplicationController
  before_action :authenticate_user!
  def today
    @todos = current_user.todos.today
    render_after_cancel_button("today")
  end

  def upcoming
    @todos = current_user.todos.upcoming.order(due_at: :desc)
    render_after_cancel_button("upcoming")
  end

  def archived
    @todos = current_user.todos.archived.order(due_at: :desc)
  end

  private
    # 新規作成・編集 キャンセルボタンの後の処理
    def render_after_cancel_button(source)
      respond_to do |format|
        format.html   # HTMLで通常のページ遷移するとき
        format.turbo_stream do
          if params[:mode] == "edit" && params[:todo_id].present?
            @todo = current_user.todos.find(params[:todo_id])
            render turbo_stream:
            turbo_stream.replace(
              "todo_#{@todo.id}",
              partial: "todos/todo",
              locals: { todo: @todo, source: source }
            )
          else
            render turbo_stream:
            turbo_stream.replace(
              "add_todo_button_#{source}",
              partial:  "lists/add_todo_button",
              locals:   { source: source }
            )
          end
        end
      end
    end
end
