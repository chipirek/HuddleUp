class Task < ActiveRecord::Base
  attr_accessible :completed_at, :due_date, :duration, :is_complete, :milestone_id, :position, :subject

  validates_presence_of :subject
  belongs_to :milestone

end
