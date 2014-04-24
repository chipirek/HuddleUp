class MessagesController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :message, :through => :project

  # GET /messages
  # GET /messages.json
  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @messages = Message.where('project_id=?', params[:project_id])
    @messages = @project.messages
    @message = Message.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end


  # GET /messages/1
  # GET /messages/1.json
  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end


  # GET /messages/new
  # GET /messages/new.json
  def new
    # no longer needed, since authorization via CanCan loads these resources
    #@project = Project.find(params[:project_id])
    @message = Message.new
    @message.project_id = params[:project_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end


  # GET /messages/1/edit
  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @message = Message.find(params[:id])
    @message.project_id = params[:project_id]
  end


  # POST /messages
  # POST /messages.json
  def create
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @message = Message.new(params[:message])
    @message.project_id = params[:project_id]

    respond_to do |format|
      if @message.save
        @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
        format.html { redirect_to project_messages_path(@project), notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /messages/1
  # PUT /messages/1.json
  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @message = Message.find(params[:id])
    @message.update_attributes(params[:message])

    respond_to do |format|
      if @message.save
        @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()
        format.html { redirect_to project_messages_path(@project), notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to project_messages_path(@project), notice: 'Message was successfully deleted.' }
      format.json { head :no_content }
    end
  end


end
