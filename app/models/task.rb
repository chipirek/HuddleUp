class Task < ActiveRecord::Base

  attr_accessible :completed_at, :due_date, :is_complete, :milestone_id, :position, :subject, :points, :member_id

  validates_presence_of :subject
  belongs_to :milestone
  belongs_to :member

end
