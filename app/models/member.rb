class Member < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :joined_date, :project_id, :status_code, :user_id, :is_admin

  # from user...
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :display_name, :last_sign_in_at

  belongs_to :project
  belongs_to :user
  has_many :todos
  has_many :tasks

  def is_blocked?
    return (status_code.to_s == '9')
  end

end
