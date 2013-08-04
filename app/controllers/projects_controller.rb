class ProjectsController < ApplicationController

  # GET /projects
  # GET /projects.json
  def index
    @membership = Member.where('user_id=' + current_user.id.to_s).where("status_code <> '9'").pluck(:project_id)
    @projects = Project.where('id in (?)', @membership)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end


  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    puts '------------------------'
    puts 'current_user = ' + current_user.id.to_s
    puts 'project = ' + @project.id.to_s

    Member.all.each do |m|
      puts 'm.id=' + m.id.to_s
      puts 'm.user_id=' + m.user_id.to_s
      puts 'm.project_id=' + m.project_id.to_s
    end

    puts 'Count of project members found = ' + @project.members.count.to_s

    #@member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
    @member = @project.members.where('user_id=?', current_user.id).first
    if @member.nil?
      puts 'ERROR HERE --> No member found'
    else
      puts 'MEMBER FOUND!!'
    end

    #@audits = @project.audits
    #@associated_audits = @project.associated_audits

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
    @project = Project.find(params[:id])
  end


  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        @project.members.create(:user_id => current_user.id, :is_admin => true, :joined_date => Time.now )
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
