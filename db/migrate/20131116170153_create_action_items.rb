class CreateActionItems < ActiveRecord::Migration
  def change
    create_table :action_items do |t|
      t.integer :issue_id
      t.integer :member_id
      t.text :subject
      t.boolean :is_complete

      t.timestamps
    end
  end
end
