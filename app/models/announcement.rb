class Announcement < ActiveRecord::Base

  audited :associated_with => :project

  validates_presence_of :subject

  belongs_to :project

end
