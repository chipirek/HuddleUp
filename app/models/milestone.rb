class Milestone < ActiveRecord::Base
  attr_accessible :event_date, :project_id, :subject, :percent_complete

  validates_presence_of :subject
  validates_presence_of :event_date

  belongs_to :project
  has_many :tasks

  def total_points
    p=0
    tasks.each do |t|
        p += t.points
    end
    return p
  end

  def calculated_percent_complete
    tp = total_points + 1.00
    cp = 0.00
    tasks.each do |t|
      if t.is_complete
        cp += t.points
      end
    end

    return (cp/tp)*100.00
  end

end
