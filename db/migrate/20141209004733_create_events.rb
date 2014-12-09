class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :project_id
      t.string :title
      t.date :start_date
      t.date :end_date
      t.string :class_name
      t.boolean :all_day
      t.datetime :start_time
      t.datetime :end_time
      t.string :icon
      t.string :description

      t.timestamps
    end

    drop_table :milestones

  end
end
