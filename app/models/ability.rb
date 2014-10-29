class Ability
  include CanCan::Ability

  def initialize(user)

    projects_in_which_i_am_a_member = Member.where('user_id=' + user.id.to_s).where("status_code <> '9'").pluck(:project_id)

    if user.plan == 'free'
      if projects_in_which_i_am_a_member.count == 0
        can :create, Project
      else
        projects = Project.where('id in (?)', projects_in_which_i_am_a_member)
        projects.each do |project|
          can [:read, :update], Project, :id => project.id
          user_is_admin = Member.where('user_id=' + user.id.to_s).where('project_id=?', project.id).pluck(:is_admin)
          if user_is_admin
            can [:destroy], Project, :id => project.id
          end
        end
        can :read, Member
        can :manage, [Todo, Milestone, Issue, Invitation, Message, Comment]
      end

    elsif user.plan == 'silver'
      if projects_in_which_i_am_a_member.count < 6
        can :create, Project
      end
      projects = Project.where('id in (?)', projects_in_which_i_am_a_member)
      projects.each do |project|
        can [:read, :update], Project, :id => project.id
        user_is_admin = Member.where('user_id=' + user.id.to_s).where('project_id=?', project.id).pluck(:is_admin)
        if user_is_admin
          can [:destroy], Project, :id => project.id
        end
        if project.members.count < 6
          can :create, Member
        end
      end
      can :manage, [Todo, Milestone, Issue, Invitation, Message, Comment]
      can [:read, :update], Member

    elsif user.plan == 'gold'
      if projects_in_which_i_am_a_member.count < 11
        can :create, Project
      end
      projects = Project.where('id in (?)', projects_in_which_i_am_a_member)
      projects.each do |project|
        can [:read, :update], Project, :id => project.id
        user_is_admin = Member.where('user_id=' + user.id.to_s).where('project_id=?', project.id).pluck(:is_admin)
        if user_is_admin
          can [:destroy], Project, :id => project.id
        end
      end
      if project.members.count < 11
        can :create, Member
      end
      can :manage, [Todo, Milestone, Issue, Invitation, Message, Comment]
      can [:read, :update], Member

    elsif user.plan == 'platinum'
      can :create, Project
      projects = Project.where('id in (?)', projects_in_which_i_am_a_member)
      projects.each do |project|
        can [:read, :update], Project, :id => project.id
        user_is_admin = Member.where('user_id=' + user.id.to_s).where('project_id=?', project.id).pluck(:is_admin)
        if user_is_admin
          can [:destroy], Project, :id => project.id
        end
      end
      can :manage, [Todo, Milestone, Issue, Invitation, Message, Comment, Member]
    end


  end

end
