# frozen_string_literal: true

module FixtureHelpers
  def file_fixture(filename)
    File.join(Dir.getwd, "spec", "fixtures", filename)
  end
end

RSpec.configure do |config|
  config.include FixtureHelpers
end
