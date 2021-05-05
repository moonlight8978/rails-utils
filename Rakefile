# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

task :rails_env do
  require_relative "./spec/dummy/config/environment"
  Dummy::Application.load_tasks
end

task :rails, [:task_name] => [:rails_env] do |_task, args|
  Rake::Task[args[:task_name]].invoke
end

namespace :db do
  task prepare: :rails_env do
    %w[drop create migrate].each do |db_task|
      Rake::Task["db:#{db_task}"].invoke
    rescue StandardError
      nil
    end
  end

  task setup: :rails_env do
    %w[drop setup].each do |db_task|
      Rake::Task["db:#{db_task}"].invoke
    rescue StandardError
      nil
    end
  end
end
