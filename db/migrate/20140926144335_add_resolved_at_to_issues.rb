class AddResolvedAtToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :resolved_at, :date
  end
end
