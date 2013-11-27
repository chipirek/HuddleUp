class ActionItemsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @post = Post.new
    @action_item = ActionItem.new
    @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
    @action_items = @issue.action_items

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end


  # GET /action_items/new
  # GET /action_items/new.json
  def new
    @action_item = ActionItem.new
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @action_item.issue_id = params[:issue_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @action_item }
    end
  end


  # GET /action_items/1/edit
  def edit
    @action_item = ActionItem.find(params[:id])
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @action_item.issue_id = params[:issue_id]
  end


  # POST /action_items
  # POST /action_items.json
  def create
    @action_item = ActionItem.new(params[:action_item])
    @issue = Issue.find(params[:issue_id])
    @project = Project.find(params[:project_id])
    @action_item.issue_id = params[:issue_id]

    target_url = project_issue_action_items_path(@project, @issue) #request.referrer

    respond_to do |format|
      if @action_item.save
        @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
        Post.create(:issue_id=>@issue.id, :member_id=>@member.id, :body=>@member.user.name + ' added the action item "' + @action_item.subject.truncate(100) + '".') unless @member.nil?
        format.html { redirect_to target_url, notice: 'Action item was successfully created.' }
        format.json { render json: @action_item, status: :created, location: @action_item }
      else
        format.html { redirect_to target_url, alert: 'Action Item was not created.'  }
        format.json { render json: @action_item.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /action_items/1
  # PUT /action_items/1.json
  def update
    @action_item = ActionItem.find(params[:id])
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @action_item.update_attributes(params[:action_item])

    target_url = project_issue_action_items_path(@project, @issue) #request.referrer

    respond_to do |format|
      if @action_item.save
        @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
        Post.create(:issue_id=>@issue.id, :member_id=>@member.id, :body=>@member.user.name + ' updated the action item "' + @action_item.subject.truncate(100) + '".') unless @member.nil?
        format.html { redirect_to target_url, notice: 'Action item was successfully updated.' }
        format.json { render json: @action_item, status: :created, location: @action_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @action_item.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /action_items/1
  # DELETE /action_items/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @action_item = ActionItem.find(params[:id])
    @action_item.destroy

    target_url = request.referrer

    respond_to do |format|
      format.html { redirect_to target_url, notice: 'Action Item was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  def mark_complete
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @action_item = ActionItem.find(params[:id])
    @action_item.update_attribute('is_complete', true)
    @action_item.save!

    @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
    Post.create(:issue_id=>@issue.id, :member_id=>@member.id, :body=>@member.user.name + ' completed the action item "' + @action_item.subject.truncate(100) + '".')

    redirect_to request.referrer, notice: 'Action Item was marked complete.'
  end


  def mark_incomplete
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @action_item = ActionItem.find(params[:id])
    @action_item.update_attribute('is_complete', nil)
    @action_item.save!

    @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
    Post.create(:issue_id=>@issue.id, :member_id=>@member.id, :body=>@member.user.name + ' re-opened an action item "' + @action_item.subject.truncate(100) + '".')

    redirect_to request.referrer, notice: 'Action Item was marked incomplete.'
  end

end
