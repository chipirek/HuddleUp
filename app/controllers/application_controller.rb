class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  before_filter :make_sure_there_is_a_working_date
  before_filter :build_my_notifications
  before_filter :determine_current_membership

  protect_from_forgery

  around_filter :catch_not_found

  rescue_from CanCan::AccessDenied do |exception|
    puts '>>> UNAUTHORIZED: ' + exception.message
    flash[:error] = 'You do not have access to the project requested.'
    redirect_to '/projects'
  end


  private


  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Well, something went wrong. You tried to access a record that does not exist.'
    redirect_to '/projects'
  end


  protected


  def make_sure_there_is_a_working_date
    session[:working_date] = Date.today.strftime("%m/%d/%Y") unless !session[:working_date].nil?
  end


  def build_my_notifications

    if !current_user.nil?
      my_member_ids = Member.where('user_id=' + current_user.id.to_s).where("status_code <> '9'").pluck(:id)
      @my_late_todos = Todo.where('member_id in (?)', my_member_ids).where('is_complete is null').where('due_date < ?', Date.today)
      @my_active_todos = Todo.where('member_id in (?)', my_member_ids).where('is_complete is null')
    else
      @my_late_todos = []
      @my_active_todos = []
    end

  end


  def determine_current_membership
    @current_membership_id = nil

    if current_user.nil?
      return
    end

    if params[:project_id].nil?
      return
    end

    @current_membership_id = Member.where('user_id=?', current_user.id).where('project_id=?', params[:project_id]).first().id
  end

end
