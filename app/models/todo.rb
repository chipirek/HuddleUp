class Todo < ActiveRecord::Base
  attr_accessible :completed_at, :due_date, :is_complete, :position, :project_id, :subject

  validates_presence_of :subject
  belongs_to :project

end
