class Todo < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :completed_at, :due_date, :is_complete, :position, :project_id, :subject, :member_id, :description

  validates_presence_of :subject
  belongs_to :project
  belongs_to :member

end
