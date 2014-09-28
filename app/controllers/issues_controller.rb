class IssuesController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :issue, :through => :project

  # GET /issues
  # GET /issues.json
  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issues = Issue.where('project_id=?', params[:project_id]).order('position')
    @issues = @project.issues.order('position')

    respond_to do |format|
      format.html
      format.json { render json: @issues }
    end
  end


  # GET /issues/1
  # GET /issues/1.json
  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
    @issue.project_id = params[:project_id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end


  # GET /issues/new
  # GET /issues/new.json
  def new
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    @issue = Issue.new
    @issue.project_id = params[:project_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end


  # GET /issues/1/edit
  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
    @issue.project_id = params[:project_id]
  end


  # POST /issues
  # POST /issues.json
  def create
    # no longer needed, since authorization via CanCan loads these resources
    #@project = Project.find(params[:project_id])

    @issue = Issue.new(params[:issue])
    @issue.project_id = params[:project_id]
    @issue.position=99

    respond_to do |format|
      if @issue.save
        format.html { redirect_to project_issues_path(@project), notice: 'Issue was successfully created.' }
        format.json { render json: @issue, status: :created, location: @issue }
      else
        format.html { render action: "new" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /issues/1
  # PUT /issues/1.json
  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])

    @issue.update_attributes(params[:issue])
    @issue.project_id = params[:project_id]
    @issue.is_resolved = !params[:issue]['is_resolved'].nil?

    respond_to do |format|
      if @issue.save
        format.html { redirect_to project_issues_path(@project), notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to project_issues_path(@project), notice: 'Issue was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  def mark_complete
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @item = Issue.find(params[:id])
    @issue.update_attribute('is_resolved', true)
    @issue.update_attribute('resolved_at', Time.now)
    @issue.save!

    redirect_to request.referrer, notice: 'Issue was marked complete.'
  end


  def mark_incomplete
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @item = Issue.find(params[:id])
    @issue.update_attribute('is_resolved', nil)
    @issue.update_attribute('resolved_at', nil)
    @issue.save!

    redirect_to request.referrer, notice: 'Issue was marked incomplete.'
  end


  def sort
    issues = Issue.where('id in (?)', params['task'])

    issues.each do |w|
      w.position = params['task'].index(w.id.to_s) + 1
      w.save!
    end

    render :nothing => true
  end


end
