class UserMailer < ActionMailer::Base

  default from: "notifications@example.com"


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

end
