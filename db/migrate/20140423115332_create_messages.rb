class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :project_id
      t.integer :member_id
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
