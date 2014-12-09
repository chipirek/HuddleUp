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
            can [:destroy, :update], Project, :id => project.id
          end
          if project.status_code.to_s < '4'
            can :update, Project, :id => project.id
            can :manage, [Todo, Event, Issue, Message, Comment], :project_id => project.id
            can :read, [Member, Invitation], :project_id => project.id
          else
            can :read, [Todo, Event, Issue, Message, Comment, Member], :project_id => project.id
          end
        end
        can :read, Member
      end

    elsif user.plan == 'silver'
      if projects_in_which_i_am_a_member.count < 5
        can :create, Project
      end
      projects = Project.where('id in (?)', projects_in_which_i_am_a_member)
      projects.each do |project|
        can :read, Project, :id => project.id
        user_is_admin = Member.where('user_id=' + user.id.to_s).where('project_id=?', project.id).pluck(:is_admin)
        if user_is_admin
          can [:destroy, :update], Project, :id => project.id
        end
        if project.status_code.to_s < '4'
          can :update, Project, :id => project.id
          can :manage, [Todo, Event, Issue, Message, Comment], :project_id => project.id
          if project.members.count < 5
            can :create, [Member, Invitation], :project_id => project.id
          else
            can :read, [Member, Invitation], :project_id => project.id
          end
        else
          can :read, [Todo, Event, Issue, Message, Comment, Member], :project_id => project.id
        end
      end
      # can :manage, [Todo, Event, Issue, Invitation, Message, Comment]
      # can [:read, :update], Member

    elsif user.plan == 'gold'
      if projects_in_which_i_am_a_member.count < 10
        can :create, Project
      end
      projects = Project.where('id in (?)', projects_in_which_i_am_a_member)
      projects.each do |project|
        can [:read, :update], Project, :id => project.id
        user_is_admin = Member.where('user_id=' + user.id.to_s).where('project_id=?', project.id).pluck(:is_admin)
        if user_is_admin
          can [:destroy], Project, :id => project.id
        end

        if project.status_code.to_s < '4'
          can :update, Project, :id => project.id
          can :manage, [Todo, Event, Issue, Message, Comment], :project_id => project.id
          if project.members.count < 10
            can :create, [Member, Invitation], :project_id => project.id
          else
            can :read, [Member, Invitation], :project_id => project.id
          end
        else
          can :read, [Todo, Event, Issue, Message, Comment, Member], :project_id => project.id
        end
      end

    elsif user.plan == 'platinum'
      can :create, Project
      projects = Project.where('id in (?)', projects_in_which_i_am_a_member)
      projects.each do |project|
        can [:read, :update], Project, :id => project.id
        user_is_admin = Member.where('user_id=' + user.id.to_s).where('project_id=?', project.id).pluck(:is_admin)
        if user_is_admin
          can [:destroy], Project, :id => project.id
        end
        #can :manage, [Todo, Event, Issue, Invitation, Message, Comment, Member]
        if project.status_code.to_s < '4'
          can :update, Project, :id => project.id
          can :manage, [Todo, Event, Issue, Message, Comment, Member, Invitation], :project_id => project.id
        else
          can :read, [Todo, Event, Issue, Message, Comment, Member], :project_id => project.id
        end
      end
    end


  end

end
