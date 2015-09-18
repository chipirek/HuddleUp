source 'http://rubygems.org'

ruby "2.0.0"
gem 'rails', '4.2.1'

gem 'thin'
gem 'pg'
gem 'devise'
gem 'jquery-rails'# , '>=2.2.1'
gem 'audited-activerecord' #, '~> 3.0'
gem 'cancan'
## gem 'figaro'  # remove because I'll keep secrets in ENV variables
gem 'newrelic_rpm'
gem 'stripe'
gem 'stripe_event'
gem 'ledermann-rails-settings'

group :development do
  gem 'taps'
  gem 'sqlite3'
  gem 'ruby-prof'
  #gem 'test-unit'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'rails_12factor'
end

group :assets do
  gem 'uglifier'
end
