class ReadReceipt < ActiveRecord::Base

  belongs_to :member
  belongs_to :message

end
