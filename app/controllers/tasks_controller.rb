class TasksController < ApplicationController

=begin
  # GET /tasks
  # GET /tasks.json
  def index
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @tasks = Task.where('project_id=?', params[:project_id]).order('position')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end
=end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @task = Task.find(params[:id])
    @task.project_id = params[:project_id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end


  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @task = Task.new
    @task.points = 4

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end


  # GET /tasks/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @task = Task.find(params[:id])
    @task.milestone_id = params[:milestone_id]
  end


  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @task.position=99
    @task.milestone_id=params[:milestone_id]

    # task: hack to overcome Ruby 1.9 date parse bug
    if params[:task][:due_date]
      buffer = params[:task][:due_date].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @task.due_date = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to project_milestone_path(@project, @milestone), notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @task = Task.find(params[:id])
    @task.update_attributes(params[:task])
    @task.milestone_id = params[:milestone_id]

    # task: hack to overcome Ruby 1.9 date parse bug
    if params[:task][:due_date]
      buffer = params[:task][:due_date].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @task.due_date = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    puts '===============>' + @task.due_date.to_s

    respond_to do |format|
      # if @task.update_attributes(params[:task])
      if @task.save
        format.html { redirect_to project_milestone_path(@project, @milestone), notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: 'Task was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  def mark_complete
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @item = Task.find(params[:id])
    @item.update_attribute('is_complete', true)
    @item.update_attribute('completed_at', Time.now)
    @item.save!

    redirect_to request.referrer, notice: 'Task was marked complete.'
  end


  def mark_incomplete
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:milestone_id])
    @item = Task.find(params[:id])
    @item.update_attribute('is_complete', nil)
    @item.update_attribute('completed_at', nil)
    @item.save!

    redirect_to request.referrer, notice: 'Task was marked incomplete.'
  end


  def sort
    @tasks = Task.where('id in (?)', params['task'])
    @tasks.each do |w|
      w.position = params['task'].index(w.id.to_s) + 1
      w.save!
    end

    render :nothing => true
  end

end
