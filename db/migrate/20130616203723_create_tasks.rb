class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :milestone_id
      t.string :subject
      t.date :due_date
      t.integer :points
      t.boolean :is_complete
      t.date :completed_at
      t.integer :position
      t.timestamps
    end
  end
end
