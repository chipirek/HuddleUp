class AddEndTimeToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :end_time, :datetime
  end
end
