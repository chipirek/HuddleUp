class ProjectsController < ApplicationController

  # GET /projects
  # GET /projects.json
  def index
    @membership = Member.where('user_id=' + current_user.id.to_s).where("status_code <> '9'").pluck(:project_id)
    @projects = Project.where('id in (?)', @membership)

    puts ' == Observation ==>' + current_user.name + ' viewed the list of projects.'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end


  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    puts ' == Observation ==>' + current_user.name + ' viewed the project ' + @project.name + ' on ' + Time.now.strftime('%m/%d/%Y at %I:%M%p')

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
    @project = Project.find(params[:id])
  end


  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        #puts ' == Observation ==>' + current_user.name + ' created the project ' + @project.name + ' on ' + Time.now.strftime('%m/%d/%Y at %I:%M%p')
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
    @project = Project.find(params[:id])

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
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.json { head :no_content }
    end
  end
end
