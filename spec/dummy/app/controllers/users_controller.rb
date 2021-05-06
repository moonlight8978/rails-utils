class UsersController < ApplicationController
  include RailsUtils::StreamableController

  def index
    respond_to do |format|
      format.csv do
        stream_csv("users.csv") do |io|
          RailsUtils::Export.new(io)
            .perform(
              RailsUtils::Export::BasicIterator.new(User.all, Export::UserCsvRow),
              headers: Export::UserCsvRow.generate_headers_line
            )
        end
      end

      format.zip do
        stream_zip("users.zip") do |write|
          write.call "users-1.csv" do |io|
            RailsUtils::Export.new(io)
              .perform(
                RailsUtils::Export::BasicIterator.new(User.all, Export::UserCsvRow),
                headers: Export::UserCsvRow.generate_headers_line
              )
          end

          write.call "users-2.csv" do |io|
            RailsUtils::Export.new(io)
              .perform(
                RailsUtils::Export::BasicIterator.new(User.all, Export::UserCsvRow),
                headers: Export::UserCsvRow.generate_headers_line
              )
          end
        end
      end
    end
  end
end
