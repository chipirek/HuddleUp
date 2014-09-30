class AddIconToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :icon, :string
  end
end
