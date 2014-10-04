class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :issue_id
      t.text :body
      t.integer :member_id
      t.timestamps
    end

    add_index :comments, :member_id #, :unique => true
    add_index :comments, :issue_id #, :unique => true

  end
end
