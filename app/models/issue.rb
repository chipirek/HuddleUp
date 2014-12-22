class Issue < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :subject, :description, :is_resolved, :member_id, :project_id,
                  :position, :is_critical

  validates_presence_of :subject

  belongs_to :project
  belongs_to :member
  has_many :comments
  has_and_belongs_to_many :categories

end
