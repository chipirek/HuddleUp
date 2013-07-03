class UserMailer < ActionMailer::Base
  default from: "notifications@example.com"
  def welcome_new_user(user, project, url)
    @user = user
    @project = project
    @url  = url
    mail(to: @user.email, subject: 'Welcome to ' + @project.name + ' at HuddleUp.comß')
  end
end
