class Invitation < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :accepted_at, :password_is_temp, :project_id, :sent_at, :user_id

end
