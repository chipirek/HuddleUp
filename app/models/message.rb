class Message < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :subject, :body, :member_id, :project_id

  validates_presence_of :subject

  belongs_to :project
  belongs_to :member

end
