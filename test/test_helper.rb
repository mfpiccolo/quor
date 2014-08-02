ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)

require "database_cleaner"  # reset database on each test run
require "rails/test_help"
require "minitest/rails"
require "minitest/pride"
require "mocha/setup"
require "self_systeem"

ActiveRecord::Migration.maintain_test_schema!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join("./test/support/**/*.rb")].sort.each { |f| require f }
