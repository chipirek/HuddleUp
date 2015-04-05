class MessagesController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :message, :through => :project


  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @messages = Message.where('project_id=?', params[:project_id])
    @messages = @project.messages
    @message = Message.new

    respond_to do |format|
      format.html # index2.html.erb
      format.json { render json: @messages }
    end
  end


  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @message = Message.find(params[:id])

    r = ReadReceipt.new
    r.member_id=Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first().id
    r.message_id=params[:id]
    r.save

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end


  def new
    # no longer needed, since authorization via CanCan loads these resources
    #@project = Project.find(params[:project_id])
    @message = Message.new
    @message.project_id = params[:project_id]
    @message.body=''

    # HACK: not sure why CanCan is allowing this, so here is a workaround...
    respond_to do |format|
      if can? :create, @project.messages.build
        format.html # new.html.erb
        format.json { render json: @message }
      else
        flash[:error] = "You don't have permission to add a new message in this project."
        format.html { redirect_to project_messages_path(@project) }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @message = Message.find(params[:id])
    @message.project_id = params[:project_id]
  end


  def create
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    @message = Message.new(message_params)
    @message.project_id = params[:project_id]
    @message.member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()

    respond_to do |format|
      if @message.save

        r = ReadReceipt.new
        r.member_id=@message.member.id
        r.message_id=@message.id
        r.save

        @member = @message.member
        format.html { redirect_to project_messages_path(@project), notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @message = Message.find(params[:id])
    @message.update_attributes(message_params)

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


  def message_params
    params.require(:message).permit(:subject, :body, :member_id, :project_id)
  end


end
