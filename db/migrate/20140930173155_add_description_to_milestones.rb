class AddDescriptionToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :description, :string
  end
end
