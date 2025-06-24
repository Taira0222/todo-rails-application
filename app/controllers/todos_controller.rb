class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: [ :update, :destroy, :edit, :copy ]

  def new
    due_date = case params[:source]
    when "today"
      Time.current
    when "upcoming"
      Time.current + 1.day
    else
      Time.current # fallback
    end

    @todo = current_user.todos.build(
      title: "",
      description: "",
      done: false,
      due_at: due_date
    )
    @new_request_token = SecureRandom.uuid
    respond_to do |format|
      format.turbo_stream # create.turbo_stream.erb を参照
    end
  end

  def create
    @todo = current_user.todos.build(todo_params)
    @todo.request_token = params[:request_token]

    if @todo.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      # new_request_token を新しい値に変更
      @new_request_token = SecureRandom.uuid
      respond_to do |format|
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html  { redirect_to today_path } # TODO: turboの実装しか考えてないのでpathは別途考える
    end
  end

  def update
    @todo.update(todo_params)
    respond_to do |format|
      format.turbo_stream
      format.html  { redirect_to today_path } # TODO: turboの実装しか考えてないのでpathは別途考える
    end
  end

  def destroy
    if @todo.destroy
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  def copy
    duplicated_params = @todo.attributes.except("id", "position", "created_at", "updated_at")
    duplicated_params["title"] = "#{@todo.title} (コピー)"

    copy_todo = current_user.todos.build(duplicated_params)
    if copy_todo.save
      @todo = copy_todo
      respond_to do |format|
        format.turbo_stream   # app/views/todos/copy.turbo_stream.erb
      end
    else
      respond_to do |format|
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end


  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description,
                                 :due_date, :due_time,  # 仮想属性
                                 :has_time, :position, :done)
  end
end
