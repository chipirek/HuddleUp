class EventsController < ApplicationController


  load_and_authorize_resource :project
  load_and_authorize_resource :event, :through => :project


  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @events = Event.where('project_id=?', params[:project_id]).order('event_date')
    @events = @project.events.order('start_date')

    respond_to do |format|
      format.html # index2.html.erb
      format.json { render json: @events }
    end
  end


  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @event = Event.find(params[:id])
    @member = Member.where('user_id=?', current_user.id).where('project_id=?', @project.id).first()

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end


  def new
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    @event = Event.new
    @event.start_date = Date.today
    @event.end_date = Date.today
    @event.project_id = params[:project_id]
    @event.class_name='bg-color-blue txt-color-white'
    @event.icon='fa-warning'
    @event.start_time=nil
    @event.end_time=nil
    @event.all_day=false

    # HACK: not sure why CanCan is allowing this, so here is a workaround...
    respond_to do |format|
      if can? :create, @project.events.build
        format.html # new.html.erb
        format.json { render json: @todo }
      else
        flash[:error] = "You don't have permission to add a new event to this project."
        format.html { redirect_to project_events_path(@project) }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @event = Event.find(params[:id])
    @event.project_id = params[:project_id]
  end


  def create
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    @event = Event.new(event_params)
    @event.project_id = params[:project_id]

    # correct date format
    begin
      if params[:event][:start_date].length > 0  # != ''
        @event.start_date = Date.strptime(params[:event][:start_date], '%m/%d/%Y')
      else
        @event.start_date = nil
      end
    rescue Exception=>e
      Rails.logger.error(e.to_s)
      @event.errors.add e.to_s
    end

    # correct date format
    begin
      if params[:event][:end_date].length > 0  # != ''
        @event.end_date = Date.strptime(params[:event][:end_date], '%m/%d/%Y')
      else
        @event.end_date = nil
      end
    rescue Exception=>e
      Rails.logger.error(e.to_s)
      @event.errors.add e.to_s
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to project_events_path(@project), notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @event = Event.find(params[:id])
    @event.update_attributes(event_params)
    @event.all_day = !params[:event]['all_day'].nil?

    if params[:event][:start_date].length == 0
      @event.errors.add(:start_date, 'Start Date is not valid.')
    else
      # TODO: hack to overcome Ruby 1.9 date parse bug
      buffer = params[:event][:start_date].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @event.start_date = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    if !(params[:event][:end_date].length == 0)
      # TODO: hack to overcome Ruby 1.9 date parse bug
      buffer = params[:event][:end_date].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @event.end_date = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to project_events_path(@project), notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to project_events_path(@project), notice: 'Event was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  private


  def event_params
    params.require(:event).permit(:project_id, :title, :start_date, :end_date, :all_day, :class_name, :icon, :description, :start_time, :end_time)
  end


end
