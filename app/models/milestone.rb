class Milestone < ActiveRecord::Base

  audited :associated_with => :project

  attr_accessible :project_id, :title, :start, :end, :all_day, :class_name, :icon,
                  :description, :start_time, :end_time

  belongs_to :project

  validates_presence_of :title
  validates_presence_of :start

  validate :date_logic_is_ok,
           :time_logic_is_ok

  def date_logic_is_ok
    if self.end.nil?
      all_day = true
      return
    end

    if self.end < start
      errors.add(:end, "can't be less than the start date.")
    end
  end

  def time_logic_is_ok
    if end_time.nil?
      all_day = true
      return
    end

    if start_time.nil?
      all_day = true
      return
    end

    if end_time < start_time
      errors.add(:end_time, "can't be less than the start time.")
    end

  end


end
