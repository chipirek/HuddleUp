class CommentsController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :issue, :through => :project
  load_and_authorize_resource :comment, :through => :issue


  def create
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @issue = Issue.find(params[:issue_id])
    # @comment = Comment.new
    @comment = Comment.new(params[:comment])
    @comment.member_id = Member.where('user_id=?', current_user.id).where('project_id=?', params[:project_id]).first().id
    @comment.issue_id = params[:issue_id]

    respond_to do |format|
      if @comment.save
        format.html { redirect_to project_issue_path(@project, @issue) }
        format.json { render json: @comment, status: :created, location: issue }
      else
        format.html { redirect_to project_issue_path(@project, @issue), error: 'Oops' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

end
