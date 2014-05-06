class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :project_id
      t.string :description
      t.boolean :is_resolved
      t.integer :member_id

      t.timestamps
    end

    add_index :issues, :member_id #, :unique => true
    add_index :issues, :project_id #, :unique => true

  end
end
