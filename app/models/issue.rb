class Issue < ActiveRecord::Base

  audited :associated_with => :project

  validates_presence_of :subject

  belongs_to :project
  belongs_to :member
  has_many :comments
  has_and_belongs_to_many :categories

end
