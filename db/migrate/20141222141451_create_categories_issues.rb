class CreateCategoriesIssues < ActiveRecord::Migration
  def change
    create_table :categories_issues do |t|
      t.belongs_to :category, index:true
      t.belongs_to :issue, index:true
    end
  end
end
