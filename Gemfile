source 'https://rubygems.org'
gem 'rails', '3.2.12'
#gem 'sqlite3'
group :production do
  gem 'pg'
end
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem "rspec-rails", ">= 2.11.0", :group => [:development, :test]
gem "capybara", ">= 1.1.2", :group => :test
gem "email_spec", ">= 1.2.1", :group => :test
gem "cucumber-rails", ">= 1.3.0", :group => :test, :require => false
gem "database_cleaner", ">= 0.8.0", :group => :test
gem "launchy", ">= 2.1.2", :group => :test
gem "factory_girl_rails", ">= 4.0.0", :group => [:development, :test]
gem "bootstrap-sass", ">= 2.0.4.0"
gem "devise", ">= 2.1.3"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "twitter"
gem "haml"
gem "haml-rails"
gem 'geocoder'
gem 'google_places'
gem 'rails_admin'

gem 'api_taster'
group :test, :development do
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'mysql2'
end
group :development do
  gem 'sextant'
  gem 'quiet_assets', '~> 1.0.1'
end
