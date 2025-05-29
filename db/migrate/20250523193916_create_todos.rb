class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :position
      t.boolean :done, default: false, null: false #defaultはfalseでまだ未完了の状態にしておきたい
      t.datetime :due_at

      t.timestamps
    end
  end
end
