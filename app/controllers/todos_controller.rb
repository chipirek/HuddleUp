class TodosController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :todo, :through => :project


  def index
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


  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @todo = Todo.find(params[:id])
    @todo.project_id = params[:project_id]
  end


  def create
    # no longer needed, since authorization via CanCan loads these resources
    #@project = Project.find(params[:project_id])
    @todo = Todo.new(todo_params)
    @todo.project_id = params[:project_id]
    @todo.position = 99

    # correct inbound date format
    begin
      if params[:todo][:due_date].length > 0  # != ''
        @todo.due_date = Date.strptime(params[:todo][:due_date], '%m/%d/%Y')
      else
        @todo.due_date = nil
      end
    rescue Exception=>e
      Rails.logger.error(e.to_s)
      @todo.errors.add e.to_s
    end

    if @todo.save
      if params[:categories]
        params[:categories].split(',').each do |id|
          @todo.categories << Category.find(id)
        end
      end

      flash[:notice] = 'Todo was successfully created.'
      redirect_to project_todos_path(@project)
    else
      flash[:error] = 'Error saving this todo.'
      redirect_to new_project_todo_path (@project)
    end

  end


  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @todo = Todo.find(params[:id])
    @todo.update_attributes(todo_params)
    @todo.project_id = params[:project_id]
    @todo.is_complete = !params[:todo]['is_complete'].nil?
    @todo.is_critical = !params[:todo]['is_critical'].nil?

    # correct inbound date format
    begin
      if params[:todo][:due_date].length > 0  # != ''
        @todo.due_date = Date.strptime(params[:todo][:due_date], '%m/%d/%Y')
      else
        @todo.due_date = nil
      end
    rescue Exception=>e
      Rails.logger.error(e.to_s)
      @todo.errors.add e.to_s
    end

    if @todo.save
      @todo.categories.destroy_all
      if params[:categories]
        params[:categories].split(',').each do |id|
          @todo.categories << Category.find(id)
        end
      end

      flash[:notice] = 'Todo was successfully updated.'
      redirect_to project_todos_path(@project)
    else
      flash[:error] = 'Error saving this todo.'
      redirect_to edit_project_todo_path @project
    end
  end


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


  private


  def todo_params
    params.require(:todo).permit(:completed_at, :due_date, :is_complete, :position, :project_id, :subject, :member_id, :description, :is_critical)
  end


end
