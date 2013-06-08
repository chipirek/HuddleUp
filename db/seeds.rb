

puts 'Seeding users...'

User.destroy_all

User.create( :name => 'Chip Irek', :email => 'chip.irek@gmail.com', :password => 'lollip0p' )  # no, not my real password
User.create( :name => 'Max Power', :email => 'max.power@gmail.com', :password => 'lollip0p' )  # no, not my real password

