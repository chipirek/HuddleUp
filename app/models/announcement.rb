class Announcement < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :body, :expires_at, :member_id, :project_id, :subject

  validates_presence_of :subject

  belongs_to :project

end
