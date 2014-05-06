class CreateReadReceipts < ActiveRecord::Migration
  def change
    create_table :read_receipts do |t|
      t.integer :member_id
      t.integer :message_id

      t.timestamps
    end

    add_index :read_receipts, :member_id #, :unique => true
    add_index :read_receipts, :message_id #, :unique => true

  end
end
