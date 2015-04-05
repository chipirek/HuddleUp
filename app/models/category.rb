class Category < ActiveRecord::Base

  belongs_to :project
  has_and_belongs_to_many :todos
  has_and_belongs_to_many :issues

  validates_presence_of :name

end
