class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :member_id
      t.boolean :password_is_temp
      t.datetime :sent_at
      t.datetime :accepted_at
      t.timestamps
    end

    add_index :invitations, :member_id # , :unique => true

  end
end
