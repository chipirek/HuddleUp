class MembersController < ApplicationController

  load_and_authorize_resource :project
  #load_and_authorize_resource :member, :through => :project

  # GET /members
  # GET /members.json
  def index
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @members = Member.where('project_id=?', params[:project_id])

    @members = @project.members
    my_member = Member.where('project_id=?', params[:project_id]).where('user_id=?', current_user.id).first
    @i_am_an_admin = my_member.is_admin

    respond_to do |format|
      format.html # index2.html.erb
      format.json { render json: @members }
    end
  end


  # GET /members/1
  # GET /members/1.json
  def show
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
    end
  end


  # GET /members/new
  # GET /members/new.json
  def new
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end


  # GET /members/1/edit
  def edit
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.find(params[:id])
  end


  # POST /members
  # POST /members.json
  def create
    #@project = Project.find(params[:project_id])
    #@member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        format.html { redirect_to project_members_path(@project), notice: 'Member was successfully created.' }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /members/1
  # PUT /members/1.json
  def update
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to project_members_path(@project), notice: 'Member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end


  def make_admin
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.find(params[:id])
    @member.is_admin=true

    respond_to do |format|
      if @member.save
        format.html { redirect_to project_members_path(@project), notice: @member.user.name + ' is now an admin.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end


  def remove_admin
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.find(params[:id])
    @member.is_admin = false

    respond_to do |format|
      if @member.save
        format.html { redirect_to project_members_path(@project), notice: @member.user.name + ' is no longer an admin.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end


  def block
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.find(params[:id])
    @member.status_code=9

    respond_to do |format|
      if @member.save
        format.html { redirect_to project_members_path(@project), notice: @member.user.name + ' is now blocked.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end


  def unblock
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.find(params[:id])
    @member.status_code=4

    respond_to do |format|
      if @member.save
        format.html { redirect_to project_members_path(@project), notice: @member.user.name + ' is now unblocked.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    # no longer needed, since authorization via CanCan loads these resources
    # @project = Project.find(params[:project_id])
    # @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to project_members_path(@project) }
      format.json { head :no_content }
    end
  end


end
