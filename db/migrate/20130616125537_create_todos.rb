class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :project_id
      t.string :subject
      t.date :due_date
      t.boolean :is_complete
      t.date :completed_at
      t.integer :position
      t.timestamps
    end
  end
end
