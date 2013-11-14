class PostsController < ApplicationController

=begin
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
=end


  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @post.issue_id = params[:issue_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end


  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @post.issue_id = params[:issue_id]
  end


  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @issue = Issue.find(params[:issue_id])
    @project = Project.find(params[:project_id])
    @post.issue_id = params[:issue_id]

    target_url = project_issue_path(@project, @issue)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to target_url, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { redirect_to target_url, alert: 'Post was not created.'  }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @post.update_attributes(params[:post])

    target_url = project_issue_path(@project, @issue)
    if params[:target_view] == 'dashboard'
      target_url = project_path(@project)
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to target_url, notice: 'Post was successfully updated.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @issue = Issue.find(params[:issue_id])
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to project_issue_path(@project, @issue), notice: 'Post was successfully deleted.' }
      format.json { head :no_content }
    end
  end

end
