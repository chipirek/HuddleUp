class Milestone < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :event_date, :project_id, :subject, :percent_complete, :points

  validates_presence_of :subject
  validates_presence_of :event_date

  belongs_to :project


  def is_complete?
    return percent_complete == 100
  end


end
