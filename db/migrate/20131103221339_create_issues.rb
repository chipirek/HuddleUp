class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :project_id
      t.string :description
      t.boolean :is_resolved
      t.integer :member_id

      t.timestamps
    end
  end
end
