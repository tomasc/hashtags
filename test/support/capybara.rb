require 'capybara'
require 'capybara-screenshot/minitest'
require 'minitest/rails/capybara'
require 'selenium/webdriver'
require 'socket'

Capybara.ignore_hidden_elements = false

if ENV['SELENIUM_DRIVER_URL'].present?
  ip = `/sbin/ip route|awk '/scope/ { print $9 }'`
  ip = ip.gsub "\n", ""
  Capybara.server_port = "3000"
  Capybara.server_host = ip
  Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[no-sandbox headless disable-gpu] }
  )

  client = Selenium::WebDriver::Remote::Http::Default.new

  driver_options = {
    browser: :chrome,
    desired_capabilities: capabilities,
    http_client: client
  }

  if ENV['SELENIUM_DRIVER_URL'].present?
    driver_options[:browser] = :remote
    driver_options[:desired_capabilities] = :chrome
    driver_options[:url] = ENV.fetch('SELENIUM_DRIVER_URL')
  end

  Capybara::Selenium::Driver.new(app, driver_options)
end

Capybara::Screenshot.register_driver :headless_chrome do |driver, path|
  driver.save_screenshot(path)
end

Capybara.configure do |config|
  config.default_max_wait_time = 10 # seconds
end

Capybara.javascript_driver = :headless_chrome
Capybara::Screenshot.prune_strategy = :keep_last_run

class Capybara::Rails::TestCase
  before do
    Capybara.current_driver = Capybara.javascript_driver if metadata[:js] == true
  end

  after do
    Capybara.current_driver = Capybara.default_driver
  end
end
