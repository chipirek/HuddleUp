class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :project_id
      t.integer :member_id
      t.string :subject
      t.date :due_date
      t.boolean :is_complete
      t.date :completed_at
      t.integer :position
      t.timestamps
    end

    add_index :todos, :member_id #, :unique => true
    add_index :todos, :project_id #, :unique => true

  end
end
