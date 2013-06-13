class Milestone < ActiveRecord::Base
  attr_accessible :event_date, :project_id, :subject

  belongs_to :project

end
