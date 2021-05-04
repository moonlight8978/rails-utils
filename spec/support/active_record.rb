# frozen_string_literal: true

require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  database: "rails_utils_test",
  host: ENV["DB_HOST"],
  username: ENV["DB_USERNAME"],
  password: ENV["DB_PASSWORD"]
)

ActiveRecord::Base.logger = ActiveSupport::Logger.new($stdout) if ENV["SQL_DEBUG"] == "1"

class User < ActiveRecord::Base; end
