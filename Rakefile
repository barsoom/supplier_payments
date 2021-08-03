require "bundler/gem_tasks"
require "rake/clean"
CLEAN << Rake::FileList["supplier_payments-*.gem"]
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

task default: :spec
