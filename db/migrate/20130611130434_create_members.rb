class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :user_id
      t.integer :project_id
      t.date :joined_date
      t.string :status_code

      t.timestamps
    end
  end
end
