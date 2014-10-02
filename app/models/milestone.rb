class Milestone < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :project_id, :title, :start, :end, :all_day, :class_name, :icon,
                  :description, :start_time, :end_time

  validates_presence_of :title
  validates_presence_of :start

  belongs_to :project


end
