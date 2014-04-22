class ActivitiesController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @audits = []

    #audits = Audit.find_by_sql('select audited_changes, user_id, action, auditable_id, auditable_type, created_at from audits')
    audits = Audit.where('(auditable_type=? and auditable_id=?) or (associated_type=? and associated_id=?)', 'Project', params[:project_id], 'Project', params[:project_id])
    audits.each do |a|

      a.full_message = ''
      a.did_what = ''
      a.old_value = ''
      a.new_value = ''

      a.auditable_type = a.auditable_type.downcase
      a.username = User.find(a.user_id).name

      if a.action == 'create'
        a.did_what = 'added'
        a.new_value = a.audited_changes.split(':')[1]
        a.full_message = a.username + ' ' + a.did_what + ' ' + a.auditable_type + ' "' + a.new_value + '"'
      end

      if a.action == 'destroy'
        a.did_what = 'deleted'
        a.new_value = a.audited_changes.split(':')[2]
        a.full_message = a.username + ' ' + a.did_what + ' ' + a.auditable_type + ' "' + a.new_value + '"'
      end

      if a.action == 'update'
        a.did_what = 'updated'
        a.new_value = a.audited_changes.split(':')[1]
        a.full_message = a.username + ' ' + a.did_what + ' ' + a.auditable_type + ' "' + a.new_value + '"'
      end

      puts '---------------------'
      puts 'a.user_id=' + a.user_id.to_s
      puts 'a.username=' + a.username
      puts 'a.did_what=' + a.did_what
      puts 'a.auditable_id=' + a.auditable_id.to_s
      puts 'a.auditable_type=' + a.auditable_type
      puts 'a.audited_changes=' + a.audited_changes
      puts 'a.old_value=' + a.old_value
      puts 'a.new_value=' + a.new_value
      puts 'a.full_message=' + a.full_message

      @audits << a
    end
  end


  private


  def get_record_from(table, pk)
    if table == 'todo'
      return Milestone.find(pk)
    elsif table == 'project'
      return Project.find(pk)
    elsif table == 'issue'
      return Issue.find(pk)
    elsif table == 'member'
      return Member.find(pk)
    end
  end

end
