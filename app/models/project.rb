class Project < ActiveRecord::Base
  attr_accessible :description, :name, :user_id, :status_code

  validates_presence_of :name

  belongs_to :user
  has_many :members

end
