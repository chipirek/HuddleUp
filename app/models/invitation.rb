class Invitation < ActiveRecord::Base

  #audited :associated_with => :project

  attr_accessible :accepted_at, :password_is_temp, :sent_at, :member_id

  belongs_to :member

end
