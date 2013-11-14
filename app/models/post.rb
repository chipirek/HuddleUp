class Post < ActiveRecord::Base
  attr_accessible :body, :member_id, :issue_id

  validates_presence_of :body
  validates_presence_of :issue_id
  validates_presence_of :member_id

  belongs_to :issue
  belongs_to :member

end
