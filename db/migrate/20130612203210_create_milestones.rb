class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :project_id
      t.string :subject
      t.date :event_date
      t.integer :percent_complete
      t.timestamps
    end
  end
end
