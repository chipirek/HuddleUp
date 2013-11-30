class Ability
  include CanCan::Ability

  def initialize(user)

    membership = Member.where('user_id=' + user.id.to_s).where("status_code <> '9'").pluck(:project_id)
    projects = Project.where('id in (?)', membership)

    projects.each do |project|
      can :manage, Project, :id => project.id
    end

    can :manage, [Todo, Milestone, Issue, ActionItem, Invitation, Member, Post]

  end


end
