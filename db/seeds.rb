

puts 'Seeding users...'
User.destroy_all

User.create( :name => 'Chip Irek', :email => 'chip.irek@gmail.com', :password => 'lollip0p' )  # no, not my real password
puts '   Added user ' + User.first.name
User.create( :name => 'Max Power', :email => 'max.power@gmail.com', :password => 'lollip0p' )  # no, not my real password
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

