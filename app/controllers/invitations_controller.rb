class InvitationsController < ApplicationController

  # GET /invitations
  # GET /invitations.json
  def index
    @project = Project.find(params[:project_id])
    @invitations = Invitation.where('project_id=?', params[:project_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invitations }
    end
  end


  # GET /invitations/new
  # GET /invitations/new.json
  def new
    @project = Project.find(params[:project_id])
    @invitation = Invitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invitation }
    end
  end


  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.new(params[:invitation])
    @project = Project.find(params[:project_id])
    @invitation.project_id = @project.id

    user = User.find_by_email(params[:email])
    if user.nil?
      # new user
      puts '------------------- creating user and member'
      temp_password = (0...8).map{(65+rand(26)).chr}.join
      user = User.create( :name => params[:name], :email => params[:email], :password => temp_password )
      member = Member.create(:user_id=>user.id, :project_id=>@project.id, :is_admin=>false, :status_code=>2)
      UserMailer.welcome_new_user(user, @project, 'xyz').deliver
      puts '------------------- mail sent'
      @invitation.password_is_temp=true
      @invitation.sent_at=Time.now
      @invitation.user_id=user.id
    else
      @invitation.password_is_temp=false
      # existing user
      member = Member.create(:user_id=>user.id, :project_id=>@project.id, :is_admin=>false, :status_code=>2)
      # TODO **************** SEND EMAIL HERE
    end

    respond_to do |format|
      if @invitation.save
        puts '------------------- invitation saved'
        format.html { redirect_to project_members_path(@project), notice: 'Invitation was successfully sent.' }
      else
        format.html { render action: "new" }
      end
    end

  end


  # GET /invitations/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @invitation = Invitation.find(params[:id])
    @invitation.project_id = @project.id
  end


  # PUT /invitations/1
  # PUT /invitations/1.json
  def update
    @invitation = Invitation.find(params[:id])
    @project = Project.find(params[:project_id])
    @invitation.update_attributes(params[:invitation])

    respond_to do |format|
      if @invitation.save   #update_attributes(params[:invitation])
        format.html { redirect_to project_invitations_path(@project), notice: 'Invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end


  def accept
    @invitation = Invitation.find(params[:id])
    @project = Project.find(params[:project_id])
    @invitation.accepted_at=Time.now

    respond_to do |format|
      if @invitation.save   #update_attributes(params[:invitation])
        format.html { redirect_to project_invitations_path(@project), notice: 'Invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to project_invitations_path(@project) }
      format.json { head :no_content }
    end
  end

end
