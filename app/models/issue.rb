class Issue < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :description, :is_resolved, :member_id, :project_id

  validates_presence_of :description

  belongs_to :project
  belongs_to :member
  has_many :posts

end
