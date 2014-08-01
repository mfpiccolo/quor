source 'http://rubygems.org'
ruby '2.1.2'

gem 'rails', '~> 4.1.4'

gem 'pg', "~> 0.17.1"

gem 'json'
gem 'thin'

gem 'uglifier'
gem "jquery-rails",                 "~> 3.1.1"
gem "jquery-ui-rails",              "~> 5.0.0"

gem 'foundation-rails', '~> 5.3.1.0'
gem "font-awesome-rails",     "~> 4.1.0.0"


gem 'simple_form', '~> 3.0.0'
gem 'money-rails'
gem 'turbolinks'
gem 'kaminari', '~> 0.16.1'

gem 'devise', "~> 3.2.4"

gem 'faraday'
gem 'hashie'
gem 'xml-simple'

gem "pliable",  github: "mfpiccolo/pliable" #"~> 0.2.1"

gem "pg_search"

gem "best_in_place", github: "bernat/best_in_place", branch: "rails-4"

gem "self_systeem", path: "../../mfpiccolo/self_systeem"

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'quiet_assets'
  gem 'rails_layout'
end

group :test do
  # thincloud-test
  gem "cane", "~> 2.6"
  gem "guard-minitest", "~> 2.2.0"
  gem "simplecov", "~> 0.8"
  gem "terminal-notifier-guard", "~> 1.5"
  gem "mocha", "~> 0.14", require: false

  # thincloud-test-rails
  gem "minitest", "~> 5.3.3"
  gem "minitest-rails", "~> 2.0.0"
  gem "database_cleaner", "1.2"
  gem "factory_girl_rails", "~> 4.2.1"
end

group :development, :test do
  gem "pry-byebug"
end

group :production do
  gem 'rails_12factor'
end

gem 'sqlite3', :groups => [:test, :development]
