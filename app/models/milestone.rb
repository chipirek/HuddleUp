class Milestone < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :event_date, :project_id, :subject, :percent_complete, :points

  validates_presence_of :subject
  validates_presence_of :event_date

  belongs_to :project
  has_many :tasks

  def total_points
    p=0
    tasks.each do |t|
        p += t.points
    end
    return p * 1.00
  end

  def calculated_percent_complete
    tp = total_points
    cp = 0.00
    tasks.each do |t|
      if t.is_complete
        cp += t.points
      end
    end

    r = 0
    if tp > 0
      r = (cp/tp)*100.00
    end

    return r
  end

  def is_complete?
    return percent_complete == 100
  end

end
