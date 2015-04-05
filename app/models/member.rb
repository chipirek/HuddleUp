class Member < ActiveRecord::Base

  audited :associated_with => :project

  belongs_to :project
  belongs_to :user
  has_many :todos
  has_many :messages
  has_many :issues
  has_one :invitation

  def is_blocked?
    return (status_code.to_s == '9')
  end

end
