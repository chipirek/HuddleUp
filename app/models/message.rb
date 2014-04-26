class Message < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :id, :subject, :body, :member_id, :project_id
  #attr_accessor :is_unread

  validates_presence_of :subject

  belongs_to :project
  belongs_to :member

  has_many :read_receipts


  def is_unread?(for_member_id)
    #puts '----------------------'
    #puts 'message_id=' + id.to_s
    #puts 'read-receipts=' + read_receipts.where('member_id=?', for_member_id).count.to_s
    if read_receipts.where('member_id=?', for_member_id).count > 0
      return false
    else
      return true
    end
  end


end
