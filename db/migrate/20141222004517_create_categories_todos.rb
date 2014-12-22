class CreateCategoriesTodos < ActiveRecord::Migration
  def change
    create_table :categories_todos do |t|
      t.belongs_to :category, index:true
      t.belongs_to :todo, index:true
    end
  end
end
