class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, [Todo, Milestone, Issue, Invitation, Member, Message]

    membership = Member.where('user_id=' + user.id.to_s).where("status_code <> '9'").pluck(:project_id)

    puts '====== CanCan ======'
    puts '====== membership called ======'
    membership.each do |m|
      puts 'm=' + m.to_s
    end

    projects = Project.where('id in (?)', membership)
    puts '====== projects called count=' + projects.count.to_s
    projects.each do |project|
      puts 'project_id=' + project.id.to_s
    end

    projects.each do |project|
      can :manage, Project, :id => project.id
    end

  end


end
