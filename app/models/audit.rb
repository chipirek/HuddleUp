class Audit  < ActiveRecord::Base

  #--- these fields are added on
  attr_accessor :username, :full_message, :did_what, :title

end
