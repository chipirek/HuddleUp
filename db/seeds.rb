require 'active_record'
require 'audited'
require 'audited/adapters/active_record'
require 'audited/auditor'
require 'audited/adapters/active_record/audit'

puts 'Seeding users...'
ReadReceipt.destroy_all
Member.destroy_all
User.destroy_all

u0=User.create( :name => 'Chip Irek', :email => 'chip.irek@gmail.com', :password => 'lollip0p' )  # no, not my real password
puts '   Added user ' + User.first.name
u1=User.create( :name => 'Max Power', :email => 'max.power@gmail.com', :password => 'lollip0p' )  # no, not my real password
puts '   Added user ' + User.last.name
u2=User.create( :name => 'Bob Doe', :email => 'a@gmail.com', :password => 'lollip0p' )
puts '   Added user ' + User.last.name
u3=User.create( :name => 'John Doe', :email => 'j@gmail.com', :password => 'lollip0p' )
puts '   Added user ' + User.last.name
u4=User.create( :name => 'John Vegas', :email => 'c@gmail.com', :password => 'lollip0p' )
puts '   Added user ' + User.last.name
u5=User.create( :name => 'Tony Mandalay', :email => 'd@gmail.com', :password => 'lollip0p' )
puts '   Added user ' + User.last.name
u6=User.create( :name => 'Edgar Edge', :email => 'e@gmail.com', :password => 'lollip0p' )
puts '   Added user ' + User.last.name

Audited::Adapters::ActiveRecord::Audit.as_user(u0) do

  puts ' '
  puts 'Seeding projects...'
  Project.destroy_all

  # an agile project, a traditional project, a honey-do list, planning a party

  project1 = Project.create(:name=>"AlphaSim v0.9 (An agile software development project)", :status_code=>1, :percent_complete=>90)
  puts '   Added project ' + Project.all.first.name
  project2 = Project.create(:name=>"You should NOT see this project!!", :status_code=>2, :percent_complete=>9)
  puts '   Added project ' + Project.last.name
  project3 = Project.create(:name=>"Mom's 50th Birthday party", :status_code=>2, :percent_complete=>15, :description=>'This is a description')
  puts '   Added project ' + Project.last.name
  project4 = Project.create(:name=>"Weekend chores (A 'honey-do' list)", :status_code=>1, :percent_complete=>35)
  puts '   Added project ' + Project.last.name
  project5 = Project.create(:name=>"Build the shed (A traditional project)", :status_code=>1, :percent_complete=>60)
  puts '   Added project ' + Project.last.name

  puts ' '
  puts 'Seeding members of AlphaSim...'
  Member.destroy_all

  m = project1.members.create(:user_id=>u0.id, :joined_date=>3.days.ago, :is_admin=>true, :status_code=>1)
  puts '   Added member ' + m.user.name
  m = project1.members.create(:user_id=>u1.id, :joined_date=>2.days.ago, :is_admin=>false, :status_code=>1)
  puts '   Added member ' + m.user.name
  m = project1.members.create(:user_id=>u2.id, :joined_date=>2.days.ago, :is_admin=>false, :status_code=>1)
  puts '   Added member ' + m.user.name
  m = project1.members.create(:user_id=>u3.id, :joined_date=>20.minutes.ago, :is_admin=>false, :status_code=>1)
  puts '   Added member ' + m.user.name

  puts ' '
  puts 'Seeding members of Moms party...'

  m = project3.members.create(:user_id=>u0.id, :joined_date=>3.days.ago, :is_admin=>true, :status_code=>1)
  puts '   Added member ' + m.user.name
  m = project3.members.create(:user_id=>u1.id, :joined_date=>2.days.ago, :is_admin=>false, :status_code=>1)
  puts '   Added member ' + m.user.name

  puts ' '
  puts 'Seeding members of Weekend chores...'

  m = project4.members.create(:user_id=>u0.id, :joined_date=>3.days.ago, :is_admin=>true, :status_code=>1)
  puts '   Added member ' + m.user.name
  m = project4.members.create(:user_id=>u1.id, :joined_date=>2.days.ago, :is_admin=>false, :status_code=>1)
  puts '   Added member ' + m.user.name

  puts ' '
  puts 'Seeding members of Build the shed...'

  m = project5.members.create(:user_id=>u0.id, :joined_date=>3.days.ago, :is_admin=>true, :status_code=>1)
  puts '   Added member ' + m.user.name
  m = project5.members.create(:user_id=>u1.id, :joined_date=>2.days.ago, :is_admin=>false, :status_code=>1)
  puts '   Added member ' + m.user.name

  puts ' '
  puts 'Seeding milestones to AlphaSim...'
  Milestone.destroy_all

  m = project1.milestones.create(:subject=>'Sprint planning completed - ready to start', :event_date=>100.days.ago, :percent_complete=>100, :points=>1)
  puts '   Added milestone ' + m.subject

  m = project1.milestones.create(:subject=>'Sprint 1 complete', :event_date=>3.months.ago, :percent_complete=>100, :points=>33)
  puts '   Added milestone ' + m.subject
  m = project1.milestones.create(:subject=>'Sprint 2 complete', :event_date=>35.days.ago, :percent_complete=>100, :points=>33)
  puts '   Added milestone ' + m.subject
  m = project1.milestones.create(:subject=>'Sprint 3 complete', :event_date=>Date.tomorrow, :percent_complete=>75, :points=>33)
  puts '   Added milestone ' + m.subject

  m = project5.milestones.create(:subject=>'Initial Design', :event_date=>100.days.ago, :percent_complete=>100, :points=>1)
  puts '   Added milestone ' + m.subject

  m = project5.milestones.create(:subject=>'Engineering Design', :event_date=>90.days.ago, :percent_complete=>100, :points=>5)
  puts '   Added milestone ' + m.subject

  m = project5.milestones.create(:subject=>'Construction', :event_date=>80.days.ago, :percent_complete=>50, :points=>60)
  puts '   Added milestone ' + m.subject

  m = project5.milestones.create(:subject=>'Punchlist / Final Inspection', :event_date=>Date.tomorrow, :percent_complete=>0, :points=>33)
  puts '   Added milestone ' + m.subject

  m = project5.milestones.create(:subject=>'Signoff', :event_date=>Time.now.advance(:days=>7).to_date, :percent_complete=>0, :points=>1)
  puts '   Added milestone ' + m.subject

  puts ' '
  puts 'Seeding todos for AlphaSim...'
  Todo.destroy_all

  t = project1.todos.create(:subject=>'create the team room',:due_date=>Time.now.to_date, :position=>1, :member_id=>project1.members.first.id)
  puts '   Added todo ' + t.subject
  t = project1.todos.create(:subject=>'organize the assets',:due_date=>Time.now.to_date, :position=>2)
  puts '   Added todo ' + t.subject

  puts ' '
  puts 'Seeding todos for Moms party...'

  t = project3.todos.create(:subject=>'order the cake',:due_date=>Time.now.advance(:days=>-1).to_date, :position=>1, :is_complete=>true)
  puts '   Added todo ' + t.subject
  t = project3.todos.create(:subject=>'get catering',:due_date=>Time.now.advance(:days=>-1).to_date, :position=>2, :is_complete=>true)
  puts '   Added todo ' + t.subject
  t = project3.todos.create(:subject=>'order artwork from Amazon',:due_date=>Time.now.to_date, :position=>3)
  puts '   Added todo ' + t.subject
  t = project3.todos.create(:subject=>'shop for party favors',:due_date=>Time.now.to_date, :position=>4)
  puts '   Added todo ' + t.subject
  t = project3.todos.create(:subject=>'get a babysitter for the kids',:due_date=>Time.now.to_date, :position=>5)
  puts '   Added todo ' + t.subject

  puts ' '
  puts 'Seeding todos for Weekend chores...'

  t = project4.todos.create(:subject=>'mow the lawn',:due_date=>Time.now.to_date, :position=>2)
  puts '   Added todo ' + t.subject
  t = project4.todos.create(:subject=>'get bug spray',:due_date=>Time.now.to_date, :position=>3)
  puts '   Added todo ' + t.subject
  t = project4.todos.create(:subject=>'paint the garage',:due_date=>Time.now.to_date, :position=>4, :is_complete=>true)
  puts '   Added todo ' + t.subject
  t = project4.todos.create(:subject=>'grocery shopping',:due_date=>Time.now.advance(:days=>-1).to_date, :position=>5)
  puts '   Added todo ' + t.subject
  t = project4.todos.create(:subject=>'take Sadie to vet for check-up',:due_date=>Time.now.to_date, :position=>1)
  puts '   Added todo ' + t.subject

  puts ' '
  puts 'Removing all invitations...'
  Invitation.destroy_all

  puts ' '
  puts 'Seeding issues to AlphaSim...'
  Issue.destroy_all

  m = project1.issues.create(:description=>'This is an unresolved issue')
  puts '   Added issue ' + m.description

  m = project1.issues.create(:description=>'This is a resolved issue', :is_resolved=>true)
  puts '   Added issue ' + m.description

=begin
  puts ' '
  puts 'Creating load testing / performance testing bulk data...'


  j=0
  10000.times do |i|
    u = User.create( :name => "User " + i.to_s, :email => i.to_s + '_user@gmail.com', :password => "lollip0p" )
    p = Project.create(:name=>"Project " + i.to_s, :status_code=>2, :percent_complete=>10)
    mb = p.members.create(:user_id=>u.id, :joined_date=>3.hours.ago, :is_admin=>false, :status_code=>1)
    m = p.milestones.create(:subject=>"Milestone " + i.to_s, :event_date=>80.days.ago, :percent_complete=>50, :points=>60)
    td = m.tasks.create(:subject=>"Task " + i.to_s, :due_date=>80.days.ago, :position=>1, :points=>1, :is_complete=>true)
    ts = p.todos.create(:subject=>"Todo " + i.to_s, :due_date=>Time.now.to_date, :position=>1, :member_id=>mb.id)
    j=j+1
    if j==100
      puts '...working, i=' + i.to_s + '...'
      j=0
    end
  end
=end

  puts ' '
  puts 'Done.'

end