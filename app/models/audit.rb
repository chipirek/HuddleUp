class Audit  < ActiveRecord::Base

  #--- these fields map to the table through the ORM
  attr_accessible :description, :is_resolved, :member_id, :project_id, :user_id

  #--- these fields are added on
  attr_accessor :username, :old_value, :new_value, :full_message, :did_what

end
