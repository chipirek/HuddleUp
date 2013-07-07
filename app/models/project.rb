class Project < ActiveRecord::Base

  audited
  has_associated_audits

  attr_accessible :description, :name, :user_id, :status_code

  validates_presence_of :name

  #belongs_to :user
  has_many :members
  has_many :milestones
  has_many :todos

end
