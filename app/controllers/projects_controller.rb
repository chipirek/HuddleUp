class ProjectsController < ApplicationController

  #skip_before_filter  :authenticate_user!, :only => [:set_settings]

  load_and_authorize_resource :except=>:index


  # GET /projects
  # GET /projects.json
  def index
    # no longer needed, since authorization via CanCan loads these resources
    @membership = Member.where('user_id=' + current_user.id.to_s).where("status_code <> '9'").pluck(:project_id)

    if @membership.count == 0
      @projects = []
    else
      @projects = Project.where('id in (?)', @membership).order('status_code')
    end

    respond_to do |format|
      format.html # index2.html.erb
      format.json { render json: @projects }
    end
  end


  # GET /projects/1
  # GET /projects/1.json
  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:id])
    @member = @project.members.where('user_id=?', current_user.id).first
    @late_todos = @project.todos.where('is_complete is null').where('due_date < ?', Date.today)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end


  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end


  # GET /projects/1/edit
  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:id])
  end


  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        @project.members.create(:user_id => current_user.id, :is_admin => true, :joined_date => Time.now, :status_code=>1 )
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /projects/1
  # PUT /projects/1.json
  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy

    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:id])

    respond_to do |format|
      if @project.destroy
        format.html { redirect_to projects_path, notice: 'Project was successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @project, :alert => @projects.errors.first.message }
        format.json { head :no_content }
      end
    end
  end


  def get_settings
    @project = Project.find(params[:project_id])
    @category = Category.new

    respond_to do |format|
      format.html
      format.json { render json: @projects }
    end
  end


  def set_settings
    @project = Project.find(params[:project_id])

    # user.settings(:dashboard).theme = 'black' @todo.is_complete = !params[:todo]['is_complete'].nil?
    @project.settings(:create_milestone_for_todo_with_due_date).configured_value = !params['setting_01'].nil?
    @project.settings(:create_todo_for_event_entry).configured_value = !params['setting_02'].nil?
    @project.settings(:email_members_when_new_alert).configured_value = !params['setting_03'].nil?
    @project.save!

    flash[:notice] = 'Settings were successfully updated.'
    redirect_to project_path (@project)

  end


end
