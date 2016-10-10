require 'mongoid'
require 'database_cleaner'

DatabaseCleaner.orm = :mongoid
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  around { |tests| DatabaseCleaner.cleaning(&tests) }
end

class Capybara::Rails::TestCase
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  around { |tests| DatabaseCleaner.cleaning(&tests) }
end
