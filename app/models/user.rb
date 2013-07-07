class User < ActiveRecord::Base

  audited

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :last_sign_in_at
  # attr_accessible :title, :body

  validates_presence_of :name
  validates_presence_of :email

  # has_many :projects
  has_many :members

end
