class RemovePriorityFromMilestones < ActiveRecord::Migration
  def change
    remove_column :milestones, :priority
  end
end
