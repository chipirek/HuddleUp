class ActivitiesController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @audits = []

    #audits = Audit.find_by_sql('select audited_changes, user_id, action, auditable_id, auditable_type, created_at from audits')
    audits = Audit.where('(auditable_type=? and auditable_id=?) or (associated_type=? and associated_id=?)', 'Project', params[:project_id], 'Project', params[:project_id]).order('created_at desc')
    audits.each do |a|

      a.full_message = ''
      a.did_what = ''
      a.title = ''

      a.auditable_type = a.auditable_type.downcase
      a.username = User.find(a.user_id).name

      case a.auditable_type

        when 'project'
          case a.action
            when 'create'
              a.title = a.audited_changes.split(/\r?\n/)[1].split(':')[1]
              a.full_message = a.username + ' added the project "' + a.title.slice(1, a.title.length) + '"'
            when 'destroy'
              a.title = a.audited_changes.split(/\r?\n/)[1].split(':')[1]
              a.full_message = a.username + ' deleted the project "' + a.title.slice(1, a.title.length) + '"'
            when 'update'
              a.did_what = 'updated'
              h = a.audited_changes.split(/\r?\n/)
              h.each do |s|
                a.title += '<br />' + s unless s == '---'
              end
              a.full_message = a.username + ' ' + a.did_what + ' a ' + a.auditable_type + ' ' + a.title
            else
              a.full_message='Unknown action on todo ' + a.id.to_s
          end

        when 'todo'
          case a.action
            when 'create'
              a.title = a.audited_changes.split(/\r?\n/)[3].split(':')[1]
              a.full_message = a.username + ' added the todo "' + a.title.slice(1, a.title.length) + '"'
            when 'destroy'
              a.title = a.audited_changes.split(/\r?\n/)[3].split(':')[1]
              a.full_message = a.username + ' deleted the todo "' + a.title.slice(1, a.title.length) + '"'
            when 'update'
              a.did_what = 'updated'
              h = a.audited_changes.split(/\r?\n/)
              h.each do |s|
                a.title += '<br />' + s unless s == '---'
              end
              a.full_message = a.username + ' ' + a.did_what + ' a ' + a.auditable_type + ' ' + a.title
            else
              a.full_message='Unknown action on todo ' + a.id.to_s
          end

        when 'event'
          case a.action
            when 'create'
              a.title = a.audited_changes.split(/\r?\n/)[2].split(':')[1]
              a.full_message = a.username + ' added the event "' + a.title.slice(1, a.title.length) + '"'
            when 'destroy'
              a.title = a.audited_changes.split(/\r?\n/)[2].split(':')[1]
              a.full_message = a.username + ' deleted the event "' + a.title.slice(1, a.title.length) + '"'
            when 'update'
              a.did_what = 'updated'
              h = a.audited_changes.split(/\r?\n/)
              h.each do |s|
                a.title += '<br />' + s unless s == '---'
              end
              a.full_message = a.username + ' ' + a.did_what + ' an event ' + a.title
            else
              a.full_message='Unknown action on event ' + a.id.to_s
          end

        when 'issue'
          case a.action
            when 'create'
              a.title = a.audited_changes.split(/\r?\n/)[5].split(':')[1]
              a.full_message = a.username + ' added the issue "' + a.title.slice(1, a.title.length) + '"'
            when 'destroy'
              a.title = a.audited_changes.split(/\r?\n/)[5].split(':')[1]
              a.full_message = a.username + ' deleted the issue "' + a.title.slice(1, a.title.length) + '"'
            when 'update'
              a.did_what = 'updated'
              h = a.audited_changes.split(/\r?\n/)
              h.each do |s|
                a.title += '<br />' + s unless s == '---'
              end
              a.full_message = a.username + ' ' + a.did_what + ' an issue ' + a.title
            else
              a.full_message='Unknown action on issue ' + a.id.to_s
          end

        #when 'invitation'
        #  case a.action
        #    when 'create'
        #      a.did_what = 'added'
        #    when 'destroy'
        #      a.did_what = 'deleted'
        #    when 'update'
        #      a.did_what = 'updated'
        #    else
        #      a.did_what = a.action + "'d"
        #  end
        #  a.full_message = a.username + ' invited someone'

        when 'member'
          case a.action
            when 'create'
              a.did_what = 'added'
            when 'destroy'
              a.did_what = 'deleted'
            when 'update'
              a.did_what = 'updated'
            else
              a.did_what = a.action + "'d"
          end
          a.full_message = a.username + ' ' + a.did_what + ' the user ' + User.find(a.audited_changes.split(/\r?\n/)[1].split(':')[1]).name

        when 'message'
          case a.action
            when 'create'
              a.title = a.audited_changes.split(/\r?\n/)[3].split(':')[1]
              a.full_message = a.username + ' added the message "' + a.title.slice(1, a.title.length) + '"'
            when 'destroy'
              a.title = a.audited_changes.split(/\r?\n/)[3].split(':')[1]
              a.full_message = a.username + ' deleted the message "' + a.title.slice(1, a.title.length) + '"'
            when 'update'
              a.did_what = 'updated'
              h = a.audited_changes.split(/\r?\n/)
              h.each do |s|
                a.title += '<br />' + s unless s == '---'
              end
              a.full_message = a.username + ' ' + a.did_what + ' a ' + a.auditable_type + ' ' + a.title
            else
              a.full_message='Unknown action on message ' + a.id.to_s
          end

        else
          a.full_message = "Uh, I don't know this kind of data..." + a.action + ' ' + a.auditable_type
      end

      #puts '---------------------'
      #puts 'a.user_id=' + a.user_id.to_s
      #puts 'a.username=' + a.username
      #puts 'a.did_what=' + a.did_what
      #puts 'a.auditable_id=' + a.auditable_id.to_s
      #puts 'a.auditable_type=' + a.auditable_type
      #puts 'a.audited_changes=' + a.audited_changes
      #puts 'a.old_value=' + a.old_value
      #puts 'a.new_value=' + a.new_value
      #puts 'a.full_message=' + a.full_message

      @audits << a
    end
  end

end
