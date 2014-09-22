class Message < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :id, :subject, :body, :member_id, :project_id
  #attr_accessor :is_unread

  validates_presence_of :subject

  belongs_to :project
  belongs_to :member

  has_many :read_receipts


  def is_unread_by?(member_id)
    if read_receipts.where('member_id=?', member_id).count > 0
      return false
    else
      return true
    end
  end


end
