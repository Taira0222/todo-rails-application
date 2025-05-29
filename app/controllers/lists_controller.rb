class ListsController < ApplicationController
  before_action :authenticate_user!
  def today
    @todos = current_user.todos.today
  end

  def upcoming
    @todos = current_user.todos.upcoming
  end

  def archived
    @todos = current_user.todos.archived
  end
  

end