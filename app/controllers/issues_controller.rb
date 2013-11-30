class IssuesController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :issue, :through => :project

  # GET /issues
  # GET /issues.json
  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issues = Issue.where('project_id=?', params[:project_id])
    @issues = @project.issues

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end


  # GET /issues/1
  # GET /issues/1.json
  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
    @post = Post.new
    @action_item = ActionItem.new
    @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()

    sql = "select *
            from (select 'ACTION_ITEM' ""mytype"", issue_id, subject ""description"", updated_at, is_complete from action_items where issue_id=" + @issue.id.to_s
    sql += " union
              select 'POST' ""mytype"", issue_id, body ""description"", updated_at, null from posts where issue_id=" + @issue.id.to_s
    sql += " ) as history order by updated_at"
    @history_items = ActionItem.find_by_sql(sql)
    @history_days = @history_items.group_by { |t| t.updated_at.beginning_of_day }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end


  # GET /issues/new
  # GET /issues/new.json
  def new
    # no longer needed, since authorization via CanCan loads these resources
    #@project = Project.find(params[:project_id])
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
    # @project = Project.find(params[:project_id])
    # @issue = Issue.new(params[:issue])
    @issue.project_id = params[:project_id]

    target_url = project_issues_path(@project)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

    respond_to do |format|
      if @issue.save
        @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
        Post.create(:issue_id=>@issue.id, :member_id=>@member.id, :body=>@member.user.name + ' added this issue.') unless @member.nil?
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
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
    @issue.update_attributes(params[:issue])

    target_url = project_issues_path(@project)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

    respond_to do |format|
      if @issue.save
        @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
        Post.create(:issue_id=>@issue.id, :member_id=>@member.id, :body=>@member.user.name + ' updated this issue.')
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
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:id])
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
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @item = Issue.find(params[:id])
    @issue.update_attribute('is_resolved', true)
    @issue.save!

    @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
    Post.create(:issue_id=>@issue.id, :member_id=>@member.id, :body=>@member.user.name + ' resolved this issue.')

    redirect_to request.referrer, notice: 'Issue has been resolved.'
  end


  def mark_unresolved
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @item = Issue.find(params[:id])
    @issue.update_attribute('is_resolved', nil)
    @issue.save!

    @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
    Post.create(:issue_id=>@issue.id, :member_id=>@member.id, :body=>@member.user.name + ' re-opened this issue.')

    redirect_to request.referrer, notice: 'Issue has been re-opened.'
  end

end
