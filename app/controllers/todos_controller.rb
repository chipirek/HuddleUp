class TodosController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :todo, :through => :project

  # GET /todos
  # GET /todos.json
  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @todos = Todo.where('project_id=?', params[:project_id]).order('position')
    @todos = @project.todos.order('position')

    @todo = Todo.new
    @todo.project_id = params[:project_id]

    respond_to do |format|
      format.html # index2.html.erb
      format.json { render json: @todos }
    end
  end


  # GET /todos/1
  # GET /todos/1.json
  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @todo = Todo.find(params[:id])
    @todo.project_id = params[:project_id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @todo }
    end
  end


  # GET /todos/new
  # GET /todos/new.json
  def new
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    @todo = Todo.new
    @todo.project_id = params[:project_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @todo }
    end
  end


  # GET /todos/1/edit
  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @todo = Todo.find(params[:id])
    @todo.project_id = params[:project_id]
  end


  # POST /todos
  # POST /todos.json
  def create
    # no longer needed, since authorization via CanCan loads these resources
    #@project = Project.find(params[:project_id])

    @todo = Todo.new(params[:todo])
    @todo.project_id = params[:project_id]
    @todo.position=99
    #@todo.is_critical = !params[:todo]['is_critical'].nil?

    # TODO: hack to overcome Ruby 1.9 date parse bug
    #puts '********************'
    #puts ">" + params[:todo][:due_date] + "<"
    #puts params[:todo][:due_date].nil?
    #puts params[:todo][:due_date].length == 0
    #puts '********************'
    if params[:todo][:due_date].length > 0
      buffer = params[:todo][:due_date].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @todo.due_date = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    respond_to do |format|
      if @todo.save
        format.html { redirect_to project_todos_path(@project), notice: 'Todo was successfully created.' }
        format.json { render json: @todo, status: :created, location: @todo }
      else
        format.html { render action: "new" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /todos/1
  # PUT /todos/1.json
  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @todo = Todo.find(params[:id])

    @todo.update_attributes(params[:todo])
    @todo.project_id = params[:project_id]
    @todo.is_complete = !params[:todo]['is_complete'].nil?
    @todo.is_critical = !params[:todo]['is_critical'].nil?

    # TODO: hack to overcome Ruby 1.9 date parse bug
    if params[:todo][:due_date].length > 0
      buffer = params[:todo][:due_date].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @todo.due_date = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    respond_to do |format|
      if @todo.save
        format.html { redirect_to project_todos_path(@project), notice: 'Todo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @todo = Todo.find(params[:id])
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to project_todos_path(@project), notice: 'Todo was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  def mark_complete
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @item = Todo.find(params[:id])
    @todo.update_attribute('is_complete', true)
    @todo.update_attribute('completed_at', Time.now)
    @todo.save!

    redirect_to request.referrer, notice: 'Todo was marked complete.'
  end


  def mark_incomplete
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @item = Todo.find(params[:id])
    @todo.update_attribute('is_complete', nil)
    @todo.update_attribute('completed_at', nil)
    @todo.save!

    redirect_to request.referrer, notice: 'Todo was marked incomplete.'
  end


  def sort
    todos = Todo.where('id in (?)', params['task'])

    todos.each do |w|
      w.position = params['task'].index(w.id.to_s) + 1
      w.save!
    end

    render :nothing => true
  end


end
