

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

Project.create(:name=>'Paint the bridge', :user_id=>User.first.id, :status_code=>1)
puts '   Added project ' + Project.all.first.name
Project.create(:name=>'Encompass', :user_id=>User.first.id, :status_code=>2)
puts '   Added project ' + Project.last.name
Project.create(:name=>'Apply hotfix 77 to the main boards', :user_id=>User.first.id, :status_code=>3)
puts '   Added project ' + Project.last.name

puts ' '
puts 'Seeding members...'
Member.destroy_all

project_id = Project.first.id

m = Member.create(:project_id=>project_id, :user_id=>u0.id, :joined_date=>3.days.ago)
puts '   Added member ' + m.user.name
m = Member.create(:project_id=>project_id, :user_id=>u2.id, :joined_date=>2.days.ago)
puts '   Added member ' + m.user.name
m = Member.create(:project_id=>project_id, :user_id=>u4.id, :joined_date=>20.minutes.ago)
puts '   Added member ' + m.user.name

puts ' '
puts 'Seeding milestones...'
Milestone.destroy_all

project_id = Project.first.id

m = Milestone.create(:project_id=>project_id, :subject=>'Accomplish something early', :event_date=>3.months.ago)
puts '   Added milestone ' + m.subject

m = Milestone.create(:project_id=>project_id, :subject=>'Accomplish something in the middle', :event_date=>35.days.ago)
puts '   Added milestone ' + m.subject

m = Milestone.create(:project_id=>project_id, :subject=>'Accomplish something in the future', :event_date=>Date.tomorrow)
puts '   Added milestone ' + m.subject
