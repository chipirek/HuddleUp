class IssuesController < ApplicationController


  # GET /issues
  # GET /issues.json
  def index
    @project = Project.find(params[:project_id])
    @issues = Issue.where('project_id=?', params[:project_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end


  # GET /issues/1
  # GET /issues/1.json
  def show
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:id])
    @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end


  # GET /issues/new
  # GET /issues/new.json
  def new
    @issue = Issue.new
    @project = Project.find(params[:project_id])
    @issue.project_id = params[:project_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end


  # GET /issues/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:id])
    @issue.project_id = params[:project_id]
  end


  # POST /issues
  # POST /issues.json
  def create
    @project = Project.find(params[:project_id])
    @issue = Issue.new(params[:issue])
    @issue.project_id = params[:project_id]

    target_url = project_issues_path(@project)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

    respond_to do |format|
      if @issue.save
        format.html { redirect_to target_url, notice: 'Issue was successfully created.' }
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
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:id])
    @issue.update_attributes(params[:issue])
    # @issue.project_id = params[:project_id]

    target_url = project_issues_path(@project)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

    respond_to do |format|
      # if @issue.update_attributes(params[:issue])
      if @issue.save
        format.html { redirect_to target_url, notice: 'Issue was successfully updated.' }
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
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:id])
    @issue.destroy

    target_url = project_issues_path(@project)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

    respond_to do |format|
      format.html { redirect_to target_url, notice: 'Issue was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  def mark_resolved
    @project = Project.find(params[:project_id])
    @item = Issue.find(params[:id])
    @item.update_attribute('is_resolved', true)
    @item.save!

    redirect_to request.referrer, notice: 'Issue has been resolved.'
  end


  def mark_unresolved
    @project = Project.find(params[:project_id])
    @item = Issue.find(params[:id])
    @item.update_attribute('is_resolved', nil)
    @item.save!

    redirect_to request.referrer, notice: 'Issue has been re-opened.'
  end

end