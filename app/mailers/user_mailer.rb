class UserMailer < ActionMailer::Base

  default from: 'Customer Care at HuddleUp.com <customer.care@huddleup.com>'    #"invitations@huddleup.com"


  def welcome_new_user(member, project, url, temp_password)
    @member = member
    @project = project
    @url  = url
    @pwd = temp_password
    mail(to: @member.user.email, subject: 'Welcome to "' + @project.name + '" at HuddleUp.com')
  end


  def welcome_existing_user(member, project, url)
    @member = member
    @project = project
    @url  = url
    mail(to: @member.user.email, subject: 'Welcome to "' + @project.name + '" at HuddleUp.com')
  end


  def expire_email(user)
    mail(:to => user.email, :subject => "Subscription Cancelled")
  end


  def new_user(user)
    @user = user
    mail(to: 'chipirek@outlook.com', subject: 'New HuddleUp user registration for ' + user.name)
  end


  def deleted_user(user)
    @user = user
    mail(to: 'chipirek@outlook.com', subject: 'Cancelled HuddleUp user account for ' + user.name)
  end


  def updated_user(user)
    @user = user
    mail(to: 'chipirek@outlook.com', subject: 'Financial HuddleUp user account change for ' + user.name)
  end


end
