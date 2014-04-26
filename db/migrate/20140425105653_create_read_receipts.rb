class CreateReadReceipts < ActiveRecord::Migration
  def change
    create_table :read_receipts do |t|
      t.integer :member_id
      t.integer :message_id

      t.timestamps
    end
  end
end
