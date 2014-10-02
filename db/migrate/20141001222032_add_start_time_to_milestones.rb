class AddStartTimeToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :start_time, :datetime
  end
end
