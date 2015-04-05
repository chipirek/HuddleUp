class Comment < ActiveRecord::Base

  audited :associated_with => :issue

  validates_presence_of :body

  belongs_to :issue
  belongs_to :member

end
