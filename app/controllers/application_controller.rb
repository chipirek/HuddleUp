class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  before_filter :make_sure_there_is_a_working_date
  before_filter :build_my_notifications

  protect_from_forgery


  protected


  def make_sure_there_is_a_working_date
    session[:working_date] = Date.today.strftime("%m/%d/%Y") unless !session[:working_date].nil?
  end


  def build_my_notifications

    if !current_user.nil?
      my_member_ids = Member.where('user_id=' + current_user.id.to_s).where("status_code <> '9'").pluck(:id)

      #puts '---------------------------------------------------------'
      #puts 'current_user=' + current_user.id.to_s
      #puts 'my_member_ids=' + my_member_ids.map(&:inspect).join(', ')
      #active_projects = Project.where('id in (?)', active_membership)

      @my_late_todos = Todo.where('member_id in (?)', my_member_ids).where('is_complete is null').where('due_date < ?', Date.today)
      @my_active_todos = Todo.where('member_id in (?)', my_member_ids).where('is_complete is null')

    else
      @my_late_todos = []
      @my_active_todos = []
    end

  end


end
