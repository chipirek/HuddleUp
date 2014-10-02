class AddIsCriticalToAllTables < ActiveRecord::Migration
  def change
    add_column :todos, :is_critical, :boolean
    add_column :issues, :is_critical, :boolean
  end
end
