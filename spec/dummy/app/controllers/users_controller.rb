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
    end
  end
end
