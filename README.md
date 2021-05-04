# rails-utils

Rails utilities for private use.

## Installation

```ruby
gem 'rails-utils', git: "https://github.com/moonlight8978/rails-utils"
```

## Usage

#### Form

```rb
class Forms::Sudo < RailsUtils::Form
  field :password, type: :string
  field :key, type: :string
  field :return_to, type: :string

  validates :key, presence: true
  validates :return_to, presence: true
  validates :password, presence: true
  validate :password_must_match

  def session_key
    key.presence && "_password_#{key}"
  end

  private

  def password_must_match
    errors.add(:password, :mismatch) unless password.present? && model.authenticate(password)
  end
end

@form = Forms::Sudo.new(params.require(:user).permit(:password, :key, :return_to), model: current_user)
@form.valid?      # => boolean
@form.save        # Raise error, #save_model need to define to use this method
@form.session_key # Custom attr reader
```

#### Export

##### CSV Format

```rb
# Use grape-entity underhood. See more arguments and usage at https://github.com/ruby-grape/grape-entity#example
class ApplicationExportCsvRowDefinition < RailsUtils::Export::CsvRowDefinition
  format_with :date do |date|
    date.strftime("%Y-%m-%d") if date.present?
  end
end

class UserCsvRow < ApplicationExportCsvRowDefinition
  column :username, header: "Username", no: 1
  column :created_at, header: "Registration date", format_with: :date, no: 2
end

UserCsvRow.generate_line(User.create(username: "abc"), { some_context: "value" })
UserCsvRow.generate_headers_line

class UsersController < ApplicationController
  include RailsUtils::StreamableController

  def index
    stream_csv("users.csv") do |io|
      RailsUtils::Export.new(io)
        .perform(
          RailsUtils::Export::BasicIterator.new(User.all, UserCsvRow),
          headers: UserCsvRow.generate_headers_line
        )
    end
  end
end
```

#### Import

##### CSV Format

```ruby
class ImportCsvUserRow < described_class::CsvRowDefinition
  model User

  column :username, :string, no: 1
  column :is_admin, :boolean, no: 2

  validates :username, presence: true
  validates :is_admin, presence: true
  validates :is_admin, inclusion: ["0", "1"], allow_blank: true
end

class ImportController < ApplicationController
  def create
    RailsUtils::Import
      .new
      .perform(params[:file], RailsUtils::Import::BasicProcessor.new(ImportCsvUserRow))
    redirect_to({ action: :new }, notice: "Success")
  rescue StandardError => e
    @error = e.message
    render :new
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
