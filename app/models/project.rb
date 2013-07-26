class Project < ActiveRecord::Base

  after_create :create_disqus_token

  audited
  has_associated_audits

  attr_accessible :description, :name, :status_code, :token_for_disqus

  validates_presence_of :name

  #belongs_to :user
  has_many :members
  has_many :milestones
  has_many :todos

  def create_disqus_token
    update_attributes!(:token_for_disqus => SecureRandom.hex)
  end

end
