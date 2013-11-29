class ApplicationController < ActionController::Base

  around_filter :catch_not_found

  before_filter :authenticate_user!
  before_filter :make_sure_there_is_a_working_date
  before_filter :make_sure_i_have_access_to_this_project
  before_filter :build_my_notifications

  protect_from_forgery


  private


  def catch_not_found
    puts '>>> catch_not_found'
    yield
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Well, something went wrong. You tried to access a record that does not exist.'
    redirect_to '/projects'
  end


  protected


  def make_sure_i_have_access_to_this_project
    puts '>>> make_sure_i_have_access_to_this_project'
    #what project is being accessed?
    current_uri = request.env['PATH_INFO']
    puts '>>> current_uri=' + current_uri
    if current_uri.include?('projects') #this token tells me i've made a projects-oriented request
      substring_array = current_uri.split('/')
      if substring_array.size == 2
        return
      end
      puts '>>> substring_array size=' + substring_array.size.to_s
      if substring_array[2] == 'new'
        return
      else
        project_id = substring_array[2].to_i
      end
      puts '>>> project_id=' + project_id.to_s
    else
      return
    end

    #do i have permission to see it?
    my_projects = Member.where('user_id=' + current_user.id.to_s).where("status_code <> '9'").pluck(:project_id)
    puts '>>> my_projects=' + my_projects.to_yaml
    if !my_projects.include?(project_id)
      puts '>>> access denied'
      flash[:error] = 'You do not have access to that project.'
      redirect_to '/projects' #root_path
    else
      puts '>>> OK'
    end

  end


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
