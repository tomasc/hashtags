# begin
#   require 'bundler/setup'
# rescue LoadError
#   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# end

require 'bundler/gem_tasks'
require 'rake/testtask'

# APP_RAKEFILE = File.expand_path('../test/dummy/Rakefile', __FILE__)
# load 'rails/tasks/engine.rake'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test
