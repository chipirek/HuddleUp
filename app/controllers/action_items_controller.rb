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

    target_url = request.referrer

    respond_to do |format|
      if @action_item.save
        format.html { redirect_to target_url, notice: 'Action Item was successfully created.' }
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

    target_url = request.referrer

    respond_to do |format|
      if @action_item.save
        format.html { redirect_to target_url, notice: 'Action Item was successfully updated.' }
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

end
