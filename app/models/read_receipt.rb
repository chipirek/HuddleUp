class ReadReceipt < ActiveRecord::Base

  attr_accessible :member_id, :message_id

  belongs_to :member
  belongs_to :message

end
