# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "mysql2", "~> 0.5.3"
gem "rails", "~> 6.1"
gem "rake", "~> 13.0"

group :development, :test do
  gem "byebug", "~> 11.1"
  gem "rspec-rails", "~> 5.0"
  gem "rubocop", "~> 1.7"
end

group :test do
  gem "database_cleaner-active_record", "~> 2.0"
  gem "factory_bot_rails", "~> 6.1"
end
