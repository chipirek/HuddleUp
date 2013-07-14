class Project < ActiveRecord::Base

  attr_accessible :description, :name, :status_code

  validates_presence_of :name

  #belongs_to :user
  has_many :members
  has_many :milestones
  has_many :todos

end
