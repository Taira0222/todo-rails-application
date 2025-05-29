class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: [:update, :destroy, :edit]  

  def create
    due_date = case params[:source]
    when 'today'
      Date.current
    when 'upcoming'
      Date.tomorrow
    when 'archived'
      Date.yesterday
    else
      Date.current # fallback
    end

    @todo = current_user.todos.create!(
      title: "",
      description: "",
      done: false, 
      due_at: due_date
    )
    
    respond_to do |format|
      format.turbo_stream # create.turbo_stream.erb を参照
      format.html { redirect_to today_path} # TODO: turboの実装しか考えてないのでpathは別途考える
    end

  end
  
  def edit
  end

  def update
    
    if @todo.update(todo_params)
      respond_to do |format|
        format.turbo_stream
        format.html  { redirect_to today_path } # TODO: turboの実装しか考えてないのでpathは別途考える
      end
    else  
      format.turbo_stream {render turbo_stream: turbo_stream.replace(@todo, partial: "todo_new"), locals:{ todo: @todo}}
      format.html { redirect_to today_path} # TODO: turboの実装しか考えてないのでpathは別途考える
    end
  end

  def destroy
  end


  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title,:description, :position, :done, :due_at)
  end
end
