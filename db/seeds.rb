require 'active_record'
require 'audited'
require 'audited/adapters/active_record'
require 'audited/auditor'
require 'audited/adapters/active_record/audit'

puts 'Seeding users...'
ReadReceipt.destroy_all
Member.destroy_all
User.destroy_all
Project.destroy_all
Milestone.destroy_all
Todo.destroy_all
Invitation.destroy_all
Issue.destroy_all
Audit.destroy_all

u0=User.create( :name => 'Chip Irek', :email => 'chip.irek@gmail.com', :password => 'lollip0p', :plan=>'gold' )  # no, not my real password
puts '   Added user ' + User.first.name
u1=User.create( :name => 'Max Power', :email => 'max.power@gmail.com', :password => 'lollip0p' )  # no, not my real password
puts '   Added user ' + User.last.name
u2=User.create( :name => 'Karthikkarthika Viswanathan', :email => 'kviswanathan@gmail.com', :password => 'lollip0p' )
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

  project1 = Project.create(:name=>"AlphaSim v0.9 (An agile software development project)", :status_code=>1, :is_complete=>false)
  puts '   Added project ' + Project.all.first.name
  project2 = Project.create(:name=>"You should NOT see this project!!", :status_code=>2, :is_complete=>false)
  puts '   Added project ' + Project.last.name
  project3 = Project.create(:name=>"Mom's 50th Birthday party", :status_code=>2, :is_complete=>true, :description=>'This is a description')
  puts '   Added project ' + Project.last.name
  project4 = Project.create(:name=>"Weekend chores (A 'honey-do' list)", :status_code=>1, :is_complete=>false)
  puts '   Added project ' + Project.last.name
  project5 = Project.create(:name=>"Build the shed (A traditional project)", :status_code=>1, :is_complete=>false)
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

  m = project1.milestones.create(:title=>'Sprint planning completed - ready to start', :start=>100.days.ago, :end=>100.days.ago, :class_name=>'bg-color-blueLight txt-color-white')
  puts '   Added milestone ' + m.title

  m = project1.milestones.create(:title=>'Sprint 1 complete', :start=>3.months.ago, :end=>3.months.ago, :class_name=>'bg-color-blue txt-color-white', :icon=>'')
  puts '   Added milestone ' + m.title
  m = project1.milestones.create(:title=>'Sprint 2 complete', :start=>35.days.ago, :end=>35.days.ago, :class_name=>'bg-color-blue txt-color-white', :icon=>'')
  puts '   Added milestone ' + m.title
  m = project1.milestones.create(:title=>'Sprint 3 complete', :start=>Date.tomorrow, :end=>Date.tomorrow, :class_name=>'bg-color-blue txt-color-white', :icon=>'')
  puts '   Added milestone ' + m.title
  m = project1.milestones.create(:title=>'Sprint 3 review', :start=>Date.tomorrow, :end=>Date.tomorrow, :class_name=>'bg-color-red txt-color-white', :icon=>'', :start_time=>'10:00', :end_time=>'11:30')
  puts '   Added milestone ' + m.title
  m = project1.milestones.create(:title=>'Signoff', :start=>Time.now.advance(:days=>7).to_date, :end=>Time.now.advance(:days=>7).to_date, :all_day=>true, :class_name=>'bg-color-blue txt-color-white', :icon=>'')
  puts '   Added milestone ' + m.title
  m = project1.milestones.create(:title=>'Red Stand-up (30min)', :start=>Time.now.to_date, :end=>Time.now.to_date, :class_name=>'bg-color-red txt-color-white', :icon=>'', :start_time=>'15:00', :end_time=>'15:30', :all_day=>false)
  puts '   Added milestone ' + m.title

  m = project5.milestones.create(:title=>'Initial Design', :start=>100.days.ago, :end=>98.days.ago, :class_name=>'bg-color-blue txt-color-white', :icon=>'')
  puts '   Added milestone ' + m.title

  m = project5.milestones.create(:title=>'Initial Design', :start=>100.days.ago, :end=>98.days.ago, :class_name=>'bg-color-blue txt-color-white', :icon=>'')
  puts '   Added milestone ' + m.title

  m = project5.milestones.create(:title=>'Signoff', :start=>Time.now.advance(:days=>7).to_date, :all_day=>true, :class_name=>'bg-color-blue txt-color-white', :icon=>'fa-user')
  puts '   Added milestone ' + m.title

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

  m = project1.issues.create(:subject=>'This is an unresolved issue', :position=>1, :member_id=>project1.members.first.id)
  puts '   Added issue ' + m.subject

  m = project1.issues.create(:subject=>'This is a resolved issue', :is_resolved=>true, :position=>1)
  puts '   Added issue ' + m.subject


=begin

  puts ' '
  puts 'Creating load testing / performance testing bulk data...'

  150.times do |i|
    u = User.create( :name => "User " + i.to_s, :email => i.to_s + '_user@gmail.com', :password => "lollip0p" )
    p = Project.create(:name=>"Project " + i.to_s, :status_code=>2)
    mb = p.members.create(:user_id=>u.id, :joined_date=>3.hours.ago, :is_admin=>false, :status_code=>1)

    150.times do |z|
      ts = p.todos.create(:subject=>"Todo " + z.to_s, :due_date=>Time.now.to_date, :position=>1, :member_id=>mb.id)
      is = p.issues.create(:subject=>"Issue " + z.to_s, :position=>1, :member_id=>mb.id)
      ms = p.milestones.create(:title=>'Milestone' + z.to_s, :start=>Date.tomorrow, :end=>Date.tomorrow, :class_name=>'bg-color-blue txt-color-white', :icon=>'')
    end

  end

=end


  Audited::Adapters::ActiveRecord::Audit.as_user(u2) do

    puts ' '
    puts 'Adding activity from another user...'

    project1 = Project.first

    puts ' '
    puts 'Adding more milestones to AlphaSim...'

    m = project1.milestones.create(:title=>'Karthika presentation', :start=>Date.tomorrow, :end=>Date.tomorrow, :class_name=>'bg-color-red txt-color-white', :icon=>'fa-user', :start_time=>'10:00', :end_time=>'10:30', :all_day=>false)
    puts '   Added milestone ' + m.title

    puts ' '
    puts 'Adding more todos for AlphaSim...'

    t = project1.todos.create(:subject=>'prepare the presentation',:due_date=>Time.now.to_date, :position=>1)
    puts '   Added todo ' + t.subject

    puts ' '
    puts 'Adding more issues to AlphaSim...'

    m = project1.issues.create(:subject=>'Cannot find my visa', :position=>1, :member_id=>project1.members.last.id)
    puts '   Added issue ' + m.subject

  end

  puts ' '
  puts 'Done.'

end