class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, Member
    can :create, Project

    test_for_active_membership = Member.find_by_sql("select user_id from members where user_id=" + user.id.to_s + " and status_code <> '9'").count

    if test_for_active_membership > 0
      membership = Member.where('user_id=' + user.id.to_s).where("status_code <> '9'").pluck(:project_id)

      if membership.count > 0
        can :manage, [Todo, Milestone, Issue, Invitation, Member, Message, Comment]
        projects = Project.where('id in (?)', membership)
        projects.each do |project|
          can :manage, Project, :id => project.id
        end

      end

    end

  end

end
