class Audit  < ActiveRecord::Base

  attr_accessor :username, :full_message, :did_what, :title

end
