class Category < ActiveRecord::Base

  attr_accessible :name, :project_id

  belongs_to :project

  validates_presence_of :name

end
