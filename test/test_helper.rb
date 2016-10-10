ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'bundler/setup'

require 'rails/test_help'
require 'minitest'
require 'minitest/around'
require 'minitest/around/spec'
require 'minitest/autorun'
require 'minitest/rails'
require 'minitest/spec'

require 'capybara-screenshot/minitest'
require 'capybara/webkit'
require 'minitest/rails/capybara'

require 'hashtags'

Capybara.javascript_driver = :webkit
Capybara.default_max_wait_time = 5
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Webkit.configure do |config|
  config.allow_url('gravatar.com')
end

class Capybara::Rails::TestCase
  before { Capybara.current_driver = Capybara.javascript_driver if metadata[:js] == true }
  after { Capybara.current_driver = Capybara.default_driver }
end

class MiniTest::Spec
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::Assertions
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
