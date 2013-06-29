class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :user_id
      t.integer :project_id
      t.date :invited_date
      t.date :joined_date
      t.date :blocked_date
      t.string :status_code   # 1-Self-registered, 2-Invited, 3-Accepted, 4-Active, 9-blocked
      t.timestamps
    end
  end
end
