class Milestone < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :project_id, :title, :start, :end, :all_day, :css_class

  validates_presence_of :title
  validates_presence_of :start

  belongs_to :project

end
