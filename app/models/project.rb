class Project < ActiveRecord::Base

  after_create :create_disqus_token

  audited
  has_associated_audits

  attr_accessible :description, :name, :status_code, :token_for_disqus, :percent_complete

  validates_presence_of :name

  #belongs_to :user
  has_many :members
  has_many :milestones
  has_many :todos
  has_many :issues


  def create_disqus_token
    update_attributes!(:token_for_disqus => SecureRandom.hex)
  end


  def total_points
    p=0
    milestones.each do |m|
      p += m.points
    end
    return p * 1.00
  end


  def calculated_percent_complete
    tp = total_points
    cp = 0.00
    milestones.each do |m|
      milestone_achieved = true
      m.tasks.each do |t|
        if !t.is_complete
          milestone_achieved = false
        end
      end
      if milestone_achieved
        cp += m.points
      end
    end

    return (cp/tp)*100.00
  end

end
