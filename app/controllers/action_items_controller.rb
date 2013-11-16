class ActionItemsController < ApplicationController


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

    target_url = project_issue_path(@project, @issue)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

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

    target_url = project_issue_path(@project, @issue)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

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

    respond_to do |format|
      format.html { redirect_to project_issue_path(@project, @issue), notice: 'Action Item was successfully deleted.' }
      format.json { head :no_content }
    end
  end

end
