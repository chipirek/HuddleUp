class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description, :default => ''
      t.integer :status_code
      t.boolean :is_complete
      t.string :token_for_disqus
      t.timestamps
    end

  end
end
