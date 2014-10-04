class Comment < ActiveRecord::Base

  audited :associated_with => :issue

  attr_accessible :body, :member_id, :issue_id

  validates_presence_of :body

  belongs_to :issue
  belongs_to :member

end
