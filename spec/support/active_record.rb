require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  database: "rails_utils_test",
  host:     ENV["DB_HOST"],
  username: ENV["DB_USERNAME"],
  password: ENV["DB_PASSWORD"],
)

if ENV["DEBUG"] == "1"
  ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
end

class User < ActiveRecord::Base; end
