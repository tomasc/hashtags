require 'capybara-screenshot/minitest'
require 'capybara/webkit'
require 'minitest/rails/capybara'

Capybara.javascript_driver = :webkit
Capybara.default_max_wait_time = 5
Capybara::Screenshot.prune_strategy = :keep_last_run

class Capybara::Rails::TestCase
  before { Capybara.current_driver = Capybara.javascript_driver if metadata[:js] == true }
  after { Capybara.current_driver = Capybara.default_driver }
end
