# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = true
  t.verbose = true
end

RuboCop::RakeTask.new

load "lib/tasks/config.rake"

task default: ["rubocop", "test"]
