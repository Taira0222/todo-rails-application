class AddIndexTodoDueAt < ActiveRecord::Migration[8.0]
  def change
    add_index :todos, [ :done, :due_at ]
  end
end
