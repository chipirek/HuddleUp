class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :project_id
      t.string :title
      t.date :start
      t.date :end
      t.string :class_name
      t.boolean :all_day
      t.timestamps
    end

    add_index :milestones, :project_id # , :unique => true

  end
end
