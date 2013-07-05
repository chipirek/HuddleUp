

puts 'Seeding users...'
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


puts ' '
puts 'Seeding projects...'
Project.destroy_all

Project.create(:name=>'Project Alpha', :status_code=>1)
puts '   Added project ' + Project.all.first.name
Project.create(:name=>'Encompass', :status_code=>2)
puts '   Added project ' + Project.last.name
Project.create(:name=>'Apply hotfix 77 to the main boards', :status_code=>3)
puts '   Added project ' + Project.last.name

puts ' '
puts 'Seeding members of Project Alpha...'
Member.destroy_all

project_id = Project.first.id
project_id_2 = Project.last.id

m = Member.create(:project_id=>project_id, :user_id=>u0.id, :joined_date=>3.days.ago, :is_admin=>true, :status_code=>1)
puts '   Added member ' + m.user.name
m = Member.create(:project_id=>project_id, :user_id=>u1.id, :joined_date=>2.days.ago, :is_admin=>false, :status_code=>1)
puts '   Added member ' + m.user.name
m = Member.create(:project_id=>project_id, :user_id=>u2.id, :joined_date=>2.days.ago, :is_admin=>false, :status_code=>1)
puts '   Added member ' + m.user.name
m = Member.create(:project_id=>project_id_2, :user_id=>u0.id, :joined_date=>20.minutes.ago, :is_admin=>false, :status_code=>1)
puts '   Added member ' + m.user.name

puts ' '
puts 'Seeding milestones to Project Alpha...'
Milestone.destroy_all

project_id = Project.first.id

m = Milestone.create(:project_id=>project_id, :subject=>'Planning completed - ready to start', :event_date=>100.days.ago, :percent_complete=>80)
puts '   Added milestone ' + m.subject
m = Milestone.create(:project_id=>project_id, :subject=>'Accomplish something early', :event_date=>3.months.ago, :percent_complete=>70)
puts '   Added milestone ' + m.subject
m = Milestone.create(:project_id=>project_id, :subject=>'Accomplish something in the middle', :event_date=>35.days.ago, :percent_complete=>30)
puts '   Added milestone ' + m.subject
m = Milestone.create(:project_id=>project_id, :subject=>'Accomplish something in the future', :event_date=>Date.tomorrow, :percent_complete=>5)
puts '   Added milestone ' + m.subject


puts ' '
puts 'Seeding todos for Project Alpha...'
Todo.destroy_all

project_id = Project.first.id

t = Todo.create(:subject=>'create the team room',:due_date=>Time.now.to_date, :position=>1, :project_id=>project_id)
puts '   Added todo ' + t.subject
t = Todo.create(:subject=>'organize the assets',:due_date=>Time.now.to_date, :position=>2, :project_id=>project_id)
puts '   Added todo ' + t.subject


puts ' '
puts 'Seeding tasks for Planning completed...'
Task.destroy_all

project = Project.first
milestone_id = project.milestones.first.id

5.times do |i|
  t = Task.create(:subject=>'define examination ' + i.to_s,:due_date=>Time.now.to_date, :position=>1, :milestone_id=>milestone_id, :points=>1)
  puts '   Added task ' + t.subject
  t = Task.create(:subject=>'assess the infrastructure for exam ' + i.to_s,:due_date=>Time.now.to_date, :position=>2, :milestone_id=>milestone_id, :points=>8)
  puts '   Added task ' + t.subject
end

puts ' '
puts 'Removing all invitations...'
Invitation.destroy_all

puts ' '
puts 'Done.'