class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.integer :project_id
      t.string :subject
      t.text :body
      t.datetime :expires_at

      t.timestamps
    end

    drop_table :read_receipts
    drop_table :messages

  end
end
