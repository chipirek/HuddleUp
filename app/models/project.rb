class Project < ActiveRecord::Base
  attr_accessible :description, :name, :user_id, :status_code

  belongs_to :user

end
