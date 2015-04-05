class AnnouncementsController < ApplicationController


  load_and_authorize_resource :project
  load_and_authorize_resource :announcement, :through => :project


  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @announcements = Announcement.where('project_id=?', params[:project_id])
    @announcements = @project.announcements
    @announcement = Announcement.new

    respond_to do |format|
      format.html # index2.html.erb
      format.json { render json: @announcements }
    end
  end


  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @announcement = Announcement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @announcement }
    end
  end


  def new
    # no longer needed, since authorization via CanCan loads these resources
    #@project = Project.find(params[:project_id])
    @announcement = Announcement.new
    @announcement.project_id = params[:project_id]
    @announcement.body=''

    # HACK: not sure why CanCan is allowing this, so here is a workaround...
    respond_to do |format|
      if can? :create, @project.announcements.build
        format.html # new.html.erb
        format.json { render json: @announcement }
      else
        flash[:error] = "You don't have permission to add a new announcement in this project."
        format.html { redirect_to project_announcements_path(@project) }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @announcement = Announcement.find(params[:id])
    @announcement.project_id = params[:project_id]
  end


  def create
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    @announcement = Announcement.new(announcement_params)
    @announcement.project_id = params[:project_id]

    # TODO: hack to overcome Ruby 1.9 date parse bug
    if params[:announcement][:expires_at].length > 0
      buffer = params[:announcement][:expires_at].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @announcement.expires_at = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    respond_to do |format|
      if @announcement.save
        format.html { redirect_to project_announcements_path(@project), notice: 'Announcement was successfully created.' }
        format.json { render json: @announcement, status: :created, location: @announcement }
      else
        format.html { render action: "new" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @announcement = Announcement.find(params[:id])
    @announcement.update_attributes(announcement_params)

    # TODO: hack to overcome Ruby 1.9 date parse bug
    if params[:announcement][:expires_at].length > 0
      buffer = params[:announcement][:expires_at].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @announcement.expires_at = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    respond_to do |format|
      if @announcement.save
        format.html { redirect_to project_announcements_path(@project), notice: 'Announcement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @announcement = Announcement.find(params[:id])
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to project_announcements_path(@project), notice: 'Announcement was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  private


  def announcement_params
    params.require(:announcement).permit(:body, :expires_at, :member_id, :project_id, :subject)
  end


end
