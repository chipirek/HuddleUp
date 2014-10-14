class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  before_filter :make_sure_there_is_a_working_date
  # before_filter :build_my_notifications

  protect_from_forgery

  around_filter :catch_not_found

  rescue_from CanCan::AccessDenied do |exception|
    puts '>>> SECURITY VIOLATION: ' + exception.message
    flash[:error] = '>>> SECURITY VIOLATION: ' + exception.message
    # redirect_to '/projects'
    # redirect_to new_user_session_path
    redirect_to '/500.html'
  end


  private


  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Well, something went wrong. Looks like you tried to access a record that does not exist.'
    redirect_to '/projects'
  end


  protected


  def make_sure_there_is_a_working_date
    session[:working_date] = Date.today.strftime("%m/%d/%Y") unless !session[:working_date].nil?
  end


=begin
  def build_my_notifications

    if !current_user.nil?
      @my_unread_messages = []
      my_member_ids = Member.where('user_id=' + current_user.id.to_s).where("status_code <> '9'").pluck(:id)
      #puts '====== Application Controller ======'
      #puts '====== membership called ======'
      #my_member_ids.each do |m|
      #  puts 'm=' + m.to_s
      #end

      @my_late_todos = Todo.where('member_id in (?)', my_member_ids).where('is_complete is null').where('due_date < ?', Date.today)
      @my_active_todos = Todo.where('member_id in (?)', my_member_ids).where('is_complete is null')

      Member.where('user_id=?', current_user.id).each do |mbr|
        #puts 'member id=' + mbr.id.to_s
        #puts 'project id=' + mbr.project_id.to_s
        project = Project.find(mbr.project_id)
        #puts 'project=' + project.name
        #puts 'messages count=' + project.messages.count.to_s
        project.messages.each do |m|
          #puts 'message member id=' + m.member_id.to_s
          #if m.member_id != mbr.id
            if m.read_receipts.where('member_id = ?', mbr.id).count == 0
              #puts 'adding message ' + m.subject
              @my_unread_messages << m
            end
          #end
        end
      end

    else
      @my_late_todos = []
      @my_active_todos = []
      @my_unread_messages = []
    end

  end
=end

end
