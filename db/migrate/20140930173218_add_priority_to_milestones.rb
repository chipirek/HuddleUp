class AddPriorityToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :priority, :string
  end
end
