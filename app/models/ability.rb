class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, [Todo, Milestone, Issue, Invitation, Member, Message, Comment]

    membership = Member.where('user_id=' + user.id.to_s).where("status_code <> '9'").pluck(:project_id)
    projects = Project.where('id in (?)', membership)
    projects.each do |project|
      can :manage, Project, :id => project.id
    end

  end


end
