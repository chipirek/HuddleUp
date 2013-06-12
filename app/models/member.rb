class Member < ActiveRecord::Base
  attr_accessible :joined_date, :project_id, :status_code, :user_id

  belongs_to :project
  belongs_to :user

end
