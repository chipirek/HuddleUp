class InvitationsController < ApplicationController


  skip_before_filter :authenticate_user!, :only => :accept


=begin
  def index
    @project = Project.find(params[:project_id])
    @invitations = Invitation.where('project_id=?', params[:project_id])

    respond_to do |format|
      format.html # index2.html.erb
      format.json { render json: @invitations }
    end
  end
=end


  def new
    @project = Project.find(params[:project_id])
    @invitation = Invitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invitation }
    end
  end


  def create

    @invitation = Invitation.new()  #  invitation_params)
    @project = Project.find(params[:project_id])

    success_code = false

    user = User.find_by_email(params[:email])

    if user.nil?
      # new user
      temp_password = ((0...8).map{(65+rand(26)).chr}.join).to_s
      user = User.create( :name => params[:name], :email => params[:email], :password => temp_password )
      member = Member.create(:user_id=>user.id, :project_id=>@project.id, :is_admin=>false, :status_code=>2)
      @invitation.password_is_temp=true
      @invitation.sent_at=Time.now
      @invitation.member_id=member.id

      success_code = @invitation.save
      if success_code
        url = 'http://huddleup.herokuapp.com/projects/' + @project.id.to_s + '/invitations/accept/' + @invitation.id.to_s
        UserMailer.welcome_new_user(member, @project, url, temp_password).deliver
      end
    else
      # existing user
      member = Member.create(:user_id=>user.id, :project_id=>@project.id, :is_admin=>false, :status_code=>2)
      @invitation.password_is_temp=false
      @invitation.sent_at=Time.now
      @invitation.member_id=member.id
      success_code = @invitation.save
      if success_code
        url = 'http://huddleup.herokuapp.com/projects/' + @project.id.to_s + '/invitations/accept/' + @invitation.id.to_s
        UserMailer.welcome_existing_user(member, @project, url).deliver
      end
    end

    respond_to do |format|
      if success_code
        format.html { redirect_to project_members_path(@project), notice: 'Invitation was successfully sent.' }
      else
        format.html { render action: "new" }
      end
    end

  end


  def accept
    @project = Project.find(params[:project_id])
    @invitation = Invitation.find(params[:id])

    success_code = false
    @invitation.accepted_at=Time.now
    if @invitation.save
      success_code=true
    end

    member = Member.find(@invitation.member_id)
    member.status_code=4
    member.joined_date=Time.now
    if member.save
      success_code=true
    end

    respond_to do |format|
      if success_code
        format.html { redirect_to project_path(@project), notice: 'Thank you for accepting the invitation to join the project.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end

  end


=begin
  def edit
    @project = Project.find(params[:project_id])
    @invitation = Invitation.find(params[:id])
    @invitation.project_id = @project.id
  end


  def update
    @invitation = Invitation.find(params[:id])
    @project = Project.find(params[:project_id])
    @invitation.update_attributes(invitation_params)

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


  def destroy
    @project = Project.find(params[:project_id])
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to project_invitations_path(@project) }
      format.json { head :no_content }
    end
  end
=end


  private


  def invitation_params
    params.require(:invitation).permit(:accepted_at, :password_is_temp, :sent_at, :member_id)
  end


end
