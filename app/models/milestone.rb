class Milestone < ActiveRecord::Base
  attr_accessible :event_date, :project_id, :subject

  validates_presence_of :subject
  validates_presence_of :event_date

  belongs_to :project

end
