class Project < ActiveRecord::Base

  include ActionView::Helpers::DateHelper

  has_settings do |s|
    s.key :create_milestone_for_todo_with_due_date, :defaults => { :configured_value => false }
    s.key :create_todo_for_event_entry,             :defaults => { :configured_value => true }
    s.key :email_members_when_new_alert,            :defaults => { :configured_value => true }
  end

  after_create :create_disqus_token
  after_create :set_initial_settings

  audited
  has_associated_audits

  validates_presence_of :name

  #belongs_to :user
  has_many :members, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :todos, :dependent => :destroy
  has_many :issues, :dependent => :destroy
  has_many :announcements, :dependent => :destroy
  has_many :categories, :dependent => :destroy


  def set_initial_settings
    self.settings(:create_milestone_for_todo_with_due_date).value = false
    self.settings(:create_todo_for_event_entry).value = false
    self.settings(:email_members_when_new_alert).value = false
  end


  def get_last_updated_by
    #last_updated = Audit.where('(auditable_type=? and auditable_id=?) or (associated_type=? and associated_id=?)', 'Project', id, 'Project', id).order('created_at desc').first

    sql = "select * from audits where (auditable_type='Project' and auditable_id=" + id.to_s + ") union select * from audits where (associated_type='Project' and associated_id=" + id.to_s + ") order by created_at desc limit 1"
    last_updated = Audit.find_by_sql(sql).first()

    if last_updated.nil?
      return ""
    end

    who = User.find(last_updated.user_id).name
    return who + ', ' + time_ago_in_words(last_updated.created_at) + ' ago'
  end


  def how_many_todos_left
    return todos.where('is_complete != true or is_complete is null').count
    #return Todo.where('project_id=?', id).where('is_complete is NULL').count
  end


  def how_many_issues_left
    return issues.where('is_resolved != true or is_resolved is null').count
  end


  def how_many_todos_left_for_this_member(current_user_id)
    current_membership_id = determine_current_membership(current_user_id)
    return todos.where('is_complete != true or is_complete is null').where('member_id=?', current_membership_id).count
  end


  def how_many_issues_left_for_this_member(current_user_id)
    current_membership_id = determine_current_membership(current_user_id)
    return issues.where('is_resolved != true or is_resolved is null').where('member_id=?', current_membership_id).count
  end


  def determine_current_membership(current_user_id)
    current_membership_id = Member.where('user_id=?', current_user_id).where('project_id=?', id).first().id
    return current_membership_id
  end


  def current_user_is_project_admin?(current_user_id)
    current_membership = Member.where('user_id=?', current_user_id).where('project_id=?', id).first()
    return current_membership.is_admin?
  end


  #def how_many_unread_messages_for_this_member(current_user_id)
  #  current_membership_id = determine_current_membership(current_user_id)
  #  messages_current_user_has_read = 0
  #  messages.each do |m|
  #    if m.read_receipts.where('member_id=?', current_membership_id).count > 0
  #      messages_current_user_has_read += 1
  #    end
  #  end
  #
  #  badge_number_for_user = messages.count - messages_current_user_has_read
  #  return badge_number_for_user
  #end


  def how_many_active_announcements
    return announcements.where('expires_at >= ?', Date.today).count
  end


  def how_many_events_left
    return events.where('start_date>=?', Date.today).count
  end


  def create_disqus_token
    update_attributes!(:token_for_disqus => SecureRandom.hex)
  end


end
