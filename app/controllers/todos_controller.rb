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


  def planner

    if !can? :create, @project.todos.build
      no_permission = true
    end

    @todos = @project.todos.where('is_complete != true or is_complete is null').order('position')

    # HACK: not sure why CanCan is allowing this, so here is a workaround...
    respond_to do |format|
      if !no_permission
        format.html
        format.json { render json: @todos }
      else
        flash[:error] = "You don't have permission to do planning on this project."
        format.html { redirect_to project_path(@project) }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end


  def set_due_date
    @item = Todo.find(params[:id])
    @item.update_attribute('due_date', params[:due_date])
    @item.save!
    render :nothing => true
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

    # HACK: not sure why CanCan is allowing this, so here is a workaround...
    respond_to do |format|
      if can? :create, @project.todos.build
        format.html # new.html.erb
        format.json { render json: @todo }
      else
        flash[:error] = "You don't have permission to add a new todo to this project."
        format.html { redirect_to project_todos_path(@project) }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
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

    if params[:todo][:due_date].length > 0
      buffer = params[:todo][:due_date].split('/')  #we know the jQuery UI datepicker will return mm/dd/yyyy
      @todo.due_date = buffer[2] + '/' + buffer[0] + '/' + buffer[1]
    end

    if @todo.save
      params[:categories].split(',').each do |id|
        @todo.categories << Category.find(id)
      end

      flash[:notice] = 'Todo was successfully created.'
      redirect_to project_todos_path(@project)
    else
      flash[:error] = 'Error saving this todo.'
      redirect_to new_project_todo_path (@project)
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

    if @todo.save
      @todo.categories.destroy_all
      params[:categories].split(',').each do |id|
        @todo.categories << Category.find(id)
      end

      flash[:notice] = 'Todo was successfully updated.'
      redirect_to project_todos_path(@project)
    else
      flash[:error] = 'Error saving this todo.'
      redirect_to edit_project_todo_path @project
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
