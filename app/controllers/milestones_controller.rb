class MilestonesController < ApplicationController

  # GET /milestones
  # GET /milestones.json
  def index
    @project = Project.find(params[:project_id])
    @milestones = Milestone.where('project_id=?', params[:project_id]).order('event_date')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @milestones }
    end
  end


  # GET /milestones/1
  # GET /milestones/1.json
  def show
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @milestone }
    end
  end


  # GET /milestones/new
  # GET /milestones/new.json
  def new
    @milestone = Milestone.new
    @project = Project.find(params[:project_id])
    @milestone.event_date=Date.today

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @milestone }
    end
  end


  # GET /milestones/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:id])
  end


  # POST /milestones
  # POST /milestones.json
  def create
    @project = Project.find(params[:project_id])
    @milestone = Milestone.new(params[:milestone])

    respond_to do |format|
      if @milestone.save
        format.html { redirect_to project_members_path(@project), notice: 'Milestone was successfully created.' }
        format.json { render json: @milestone, status: :created, location: @milestone }
      else
        format.html { render action: "new" }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /milestones/1
  # PUT /milestones/1.json
  def update
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:id])

    respond_to do |format|
      if @milestone.update_attributes(params[:milestone])
        format.html { redirect_to project_members_path(@project), notice: 'Milestone was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /milestones/1
  # DELETE /milestones/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:id])
    @milestone.destroy

    respond_to do |format|
      format.html { redirect_to project_members_path(@project) }
      format.json { head :no_content }
    end
  end
end
