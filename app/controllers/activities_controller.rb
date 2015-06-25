class ActivitiesController < ApplicationController

  def index

    @project = Project.find(params[:project_id])

    @audits = []

    audits = Audit.find_by_sql("SELECT a.*, b.name
                                FROM audits a, users b
                                WHERE (a.user_id = b.id)
                                AND ((a.auditable_type='Project' and a.auditable_id='" + params[:project_id] + "') or (a.associated_type='Project' and a.associated_id='" + params[:project_id] + "'))
                                order by created_at desc")
    #audits = Audit.where('(auditable_type=? and auditable_id=?) or (associated_type=? and associated_id=?)', 'Project', params[:project_id], 'Project', params[:project_id]).order('created_at desc')

    audits.each do |a|

      a.full_message = ''
      a.did_what = ''
      a.title = ''

      a.auditable_type = a.auditable_type.downcase
      a.username = '<b>' + a.name + '</b> '

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
              i=0
              while i<=h.count
                if h[i] == 'name:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>name</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif h[i] == 'status_code:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>status</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif
                  i += 1
                end
              end
              a.full_message = a.username + a.did_what + " aspects of this " + a.auditable_type + a.title
            else
              a.full_message='Unknown action on project ' + a.id.to_s
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
              i=0
              while i<=h.count
                if h[i] == 'subject:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>subject</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif h[i] == 'member_id:'
                  #puts '=================='
                  #puts 'i=' + h[i]
                  #puts 'i+1=>' + h[i+1].slice(2, h[i+1].length) + '<'
                  #puts 'i+2=>' + h[i+2].slice(2, h[i+2].length) + '<'
                  id1 = h[i+1].slice(2, h[i+1].length)
                  id2 = h[i+2].slice(2, h[i+2].length)
                  #puts 'id1=>' + id1 + '<'
                  #puts 'id2=>' + id2 + '<'
                  id1.length == 0 ? name1 = "" : name1 = User.find(Member.find(id1).user_id).name
                  id2.length == 0 ? name2 = "" : name2 = User.find(Member.find(id2).user_id).name
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>assigned to</b> from "' + name1 + '" to "' + name2 + '"'
                  i += 2
                elsif h[i] == 'due_date:'
                  #if_this_is_a_true_value ? then_the_result_is_this : else_it_is_this
                  #today == ChristmasEve ? (puts "Santa's On His Way!") : (puts "Snow")
                  h[i+1].slice(2, h[i+1].length).length == 0 ? date1 = "" : date1 = Date.parse(h[i+1].slice(2, h[i+1].length)).strftime("%m/%d/%Y")
                  h[i+2].slice(2, h[i+2].length).length == 0 ? date2 = "" : date2 = Date.parse(h[i+2].slice(2, h[i+2].length)).strftime("%m/%d/%Y")
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>due date</b> from "' + date1 + '" to "' +  date2 + '"'
                  i += 2
                elsif h[i] == 'is_complete:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>completed?</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif h[i] == 'completed_at:'
                  h[i+1].slice(2, h[i+1].length).length == 0 ? date1 = "" : date1 = Date.parse(h[i+1].slice(2, h[i+1].length)).strftime("%m/%d/%Y")
                  h[i+2].slice(2, h[i+2].length).length == 0 ? date2 = "" : date2 = Date.parse(h[i+2].slice(2, h[i+2].length)).strftime("%m/%d/%Y")
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>completed on</b> from "' + date1 + '" to "' + date2 + '"'
                  i += 2
                elsif h[i] == 'description:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>description</b> (see database for details)'
                  i += 2
                elsif h[i] == 'is_critical:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>is critical?</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif
                i += 1
                end
              end
              a.full_message = a.username + ' ' + a.did_what + ' ' + a.auditable_type + ' # ' + a.id.to_s + ' ' + a.title
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
              i=0
              puts '============='
              puts a.audited_changes.to_s
              while i<=h.count
                if h[i] == 'title:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>title</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif h[i] == 'start_date:'
                  h[i+1].slice(2, h[i+1].length).length == 0 ? date1 = "" : date1 = Date.parse(h[i+1].slice(2, h[i+1].length)).strftime("%m/%d/%Y")
                  h[i+2].slice(2, h[i+2].length).length == 0 ? date2 = "" : date2 = Date.parse(h[i+2].slice(2, h[i+2].length)).strftime("%m/%d/%Y")
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>start date</b> from "' + date1 + '" to "' + date2 + '"'
                  i += 2
                elsif h[i] == 'start_time:'
                  h[i+1].slice(2, h[i+1].length).length == 0 ? date1 = "" : date1 = h[i+1].slice(2, h[i+1].length).to_datetime.strftime("%l:%M %p")
                  h[i+2].slice(2, h[i+2].length).length == 0 ? date2 = "" : date2 = h[i+2].slice(2, h[i+2].length).to_datetime.strftime("%l:%M %p")
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>start time</b> from "' + date1 + '" to "' + date2 + '"'
                  i += 2
                elsif h[i] == 'end_date:'
                  h[i+1].slice(2, h[i+1].length).length == 0 ? date1 = "" : date1 = Date.parse(h[i+1].slice(2, h[i+1].length)).strftime("%m/%d/%Y")
                  h[i+2].slice(2, h[i+2].length).length == 0 ? date2 = "" : date2 = Date.parse(h[i+2].slice(2, h[i+2].length)).strftime("%m/%d/%Y")
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>end date</b> from "' + date1 + '" to "' + date2 + '"'
                  i += 2
                elsif h[i] == 'end_time:'
                  h[i+1].slice(2, h[i+1].length).length == 0 ? date1 = "" : date1 = h[i+1].slice(2, h[i+1].length).to_datetime.strftime("%l:%M %p")
                  h[i+2].slice(2, h[i+2].length).length == 0 ? date2 = "" : date2 = h[i+2].slice(2, h[i+2].length).to_datetime.strftime("%l:%M %p")
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>end time</b> from "' + date1 + '" to "' + date2 + '"'
                  i += 2
                elsif h[i] == 'description:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>description</b> (see database for details)'
                  i += 2
                elsif h[i] == 'all_day:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>is all day?</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif
                i += 1
                end
              end
              a.full_message = a.username + ' ' + a.did_what + ' ' + a.auditable_type + ' # ' + a.id.to_s + ' ' + a.title
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
              i=0
              while i<=h.count
                if h[i] == 'subject:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>subject</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif h[i] == 'member_id:'
                  #puts '=================='
                  #puts 'i=' + h[i]
                  #puts 'i+1=>' + h[i+1].slice(2, h[i+1].length) + '<'
                  #puts 'i+2=>' + h[i+2].slice(2, h[i+2].length) + '<'
                  id1 = h[i+1].slice(2, h[i+1].length)
                  id2 = h[i+2].slice(2, h[i+2].length)
                  #puts 'id1=>' + id1 + '<'
                  #puts 'id2=>' + id2 + '<'
                  id1.length == 0 ? name1 = "" : name1 = User.find(Member.find(id1).user_id).name
                  id2.length == 0 ? name2 = "" : name2 = User.find(Member.find(id2).user_id).name
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>assigned to</b> from "' + name1 + '" to "' + name2 + '"'
                  i += 2
                elsif h[i] == 'is_resolved:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>resolved?</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif h[i] == 'resolved_at:'
                  h[i+1].slice(2, h[i+1].length).length == 0 ? date1 = "" : date1 = Date.parse(h[i+1].slice(2, h[i+1].length)).strftime("%m/%d/%Y")
                  h[i+2].slice(2, h[i+2].length).length == 0 ? date2 = "" : date2 = Date.parse(h[i+2].slice(2, h[i+2].length)).strftime("%m/%d/%Y")
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>resolved on</b> from "' + date1 + '" to "' + date2 + '"'
                  i += 2
                elsif h[i] == 'description:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>description</b> (see database for details)'
                  i += 2
                elsif h[i] == 'is_critical:'
                  a.title += '<br />&nbsp;&nbsp;&nbsp;&nbsp;-changed <b>is critical?</b> from "' + h[i+1].slice(2, h[i+1].length) + '" to "' + h[i+2].slice(2, h[i+2].length) + '"'
                  i += 2
                elsif
                i += 1
                end
              end
              a.full_message = a.username + ' ' + a.did_what + ' ' + a.auditable_type + ' # ' + a.id.to_s + ' ' + a.title
            else
              a.full_message='Unknown action on issue ' + a.id.to_s
          end

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
          a.full_message = a.username + ' ' + a.did_what + ' member "' + User.find(a.audited_changes.split(/\r?\n/)[1].split(':')[1]).name + '"'

        else
          a.full_message = "Uh, I don't know this kind of data..." + a.action + ' ' + a.auditable_type

      end

      @audits << a

    end
  end

end
