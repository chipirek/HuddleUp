class IssuesController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :issue, :through => :project


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


  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end


  def new
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    @issue = Issue.new
    @issue.project_id = params[:project_id]

    # HACK: not sure why CanCan is allowing this, so here is a workaround...
    respond_to do |format|
      if can? :create, @project.issues.build
        format.html # new.html.erb
        format.json { render json: @issue }
      else
        flash[:error] = "You don't have permission to add a new issue to this project."
        format.html { redirect_to project_issues_path(@project) }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
    @issue.project_id = params[:project_id]
  end


  def create
    # no longer needed, since authorization via CanCan loads these resources
    #@project = Project.find(params[:project_id])
    @issue = Issue.new(issue_params)
    @issue.project_id = params[:project_id]
    @issue.position=99

    if @issue.save
      if params[:categories]
        params[:categories].split(',').each do |id|
          @issue.categories << Category.find(id)
        end
      end

      flash[:notice] = 'Issue was successfully created.'
      redirect_to project_issues_path(@project)
    else
      flash[:error] = 'Error saving this issue.'
      redirect_to new_project_issue_path (@project)
    end
  end


  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
    @issue.update_attributes(issue_params)
    @issue.project_id = params[:project_id]
    @issue.is_resolved = !params[:issue]['is_resolved'].nil?
    @issue.is_critical = !params[:issue]['is_critical'].nil?

    if @issue.save
      @issue.categories.destroy_all
      if params[:categories]
        params[:categories].split(',').each do |id|
          @issue.categories << Category.find(id)
        end
      end

      flash[:notice] = 'Issue was successfully updated.'
      redirect_to project_issues_path(@project)
    else
      flash[:error] = 'Error saving this issue.'
      redirect_to edit_project_issue_path @project
    end
  end


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


  def issue_params
    params.require(:issue).permit(:subject, :description, :is_resolved, :member_id, :project_id, :position, :is_critical)
  end


end
