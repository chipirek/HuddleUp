class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :project_id
      t.integer :user_id
      t.boolean :password_is_temp
      t.datetime :sent_at
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
