class ProjectsController < ApplicationController

  load_and_authorize_resource

  # GET /projects
  # GET /projects.json
  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @membership = Member.where('user_id=' + current_user.id.to_s).where("status_code <> '9'").pluck(:project_id)
    # @projects = Project.where('id in (?)', @membership)

    respond_to do |format|
      format.html # index.html.erb
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
    @project.percent_complete = 0

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
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.json { head :no_content }
    end
  end


end
