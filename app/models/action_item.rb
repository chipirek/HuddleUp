class ActionItem < ActiveRecord::Base
  attr_accessible :is_complete, :issue_id, :member_id, :subject

  validates_presence_of :subject
  validates_presence_of :issue_id

  belongs_to :issue
  belongs_to :member

end
