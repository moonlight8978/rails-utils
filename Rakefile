# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

task :db do
  require_relative "./spec/support/active_record"

  ActiveRecord::Migration.drop_table :users
  ActiveRecord::Migration.create_table :users, force: true do |t|
    t.string :username
    t.boolean :is_admin

    t.timestamps
  end
end
