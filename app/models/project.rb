class Project < ActiveRecord::Base

  after_create :create_disqus_token

  audited
  has_associated_audits

  attr_accessible :description, :name, :status_code, :token_for_disqus, :is_complete

  validates_presence_of :name

  #belongs_to :user
  has_many :members
  has_many :milestones
  has_many :todos
  has_many :issues
  has_many :messages


  def how_many_todos_for_this_member
    return todos.where('is_complete is NULL').count
    #return Todo.where('project_id=?', id).where('is_complete is NULL').count
  end


  def how_many_issues_left
    return issues.where('is_resolved is NULL').count
  end


  def determine_current_membership(current_user_id)
    current_membership_id = Member.where('user_id=?', current_user_id).where('project_id=?', id).first().id
    return current_membership_id
  end


  def how_many_unread_messages_for_this_member(current_user_id)
    #puts '-------------------'
    #puts 'current_user_id=' + current_user_id.to_s
    current_membership_id = determine_current_membership(current_user_id)
    #puts 'member_id=' + current_membership_id.to_s
    messages_current_user_has_read = 0
    messages.each do |m|
      #puts 'read_receipts for member=' + m.read_receipts.where('member_id=?', current_membership_id).count.to_s
      if m.read_receipts.where('member_id=?', current_membership_id).count > 0
        messages_current_user_has_read += 1
      end
    end

    badge_number_for_user = messages.count - messages_current_user_has_read
    #puts 'badge_number_for_user=' + badge_number_for_user.to_s
    return badge_number_for_user
  end


  def how_many_milestones_left
    return milestones.where('start>=?', Date.today).count
  end


  def create_disqus_token
    update_attributes!(:token_for_disqus => SecureRandom.hex)
  end


end
