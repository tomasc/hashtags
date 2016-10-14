ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'bundler/setup'
require 'rails/test_help'

require 'minitest'
require 'minitest/around'
require 'minitest/around/spec'
require 'minitest/autorun'
require 'minitest/fail_fast'
require 'minitest/rails'
require 'minitest/spec'

require 'slim'
require 'hashtags'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class MiniTest::Spec
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::Assertions
end
