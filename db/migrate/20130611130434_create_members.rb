class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :user_id
      t.integer :project_id
      t.boolean :is_admin
      t.datetime :joined_date
      t.string :status_code   # 1-Self-registered, 2-Invited, 3-Accepted, 4-Active, 9-blocked
      t.timestamps
    end

    add_index :members, :user_id #, :unique => true
    add_index :members, :project_id #, :unique => true

  end
end
