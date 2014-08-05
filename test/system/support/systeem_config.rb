require "test_helper"
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../../../config/environment", __FILE__)

require "rails/test_help"

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

module SysteemConfig
  Features = Dir["./" + SelfSysteem.test_dir + "/system/support/affirmations/**/*.yml"].reject {|f| f[/_db|_session/]}
  Session = ActionController::TestSession.new
end

if defined? Devise::TestHelpers
  class ActionController::TestCase
    include Devise::TestHelpers
  end
end
