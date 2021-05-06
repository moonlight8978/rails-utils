# rails-utils

[![rails-utils](https://circleci.com/gh/moonlight8978/rails-utils.svg?style=shield)](https://app.circleci.com/pipelines/github/moonlight8978/rails-utils)

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
@form.save        # Override #save_model to custom save logic, default to `model.update`
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
    respond_to do |format|
      format.csv do
        stream_csv("users.csv") do |io|
          RailsUtils::Export.new(io)
            .perform(
              RailsUtils::Export::BasicIterator.new(User.all, UserCsvRow),
              headers: UserCsvRow.generate_headers_line
            )
        end
      end

      format.zip do
        stream_zip("users.zip") do |write|
          write.call "users-1.csv" do |io|
            RailsUtils::Export.new(io)
              .perform(
                RailsUtils::Export::BasicIterator.new(User.all, UserCsvRow),
                headers: UserCsvRow.generate_headers_line
              )
          end

          write.call "users-2.csv" do |io|
            RailsUtils::Export.new(io)
              .perform(
                RailsUtils::Export::BasicIterator.new(User.all, UserCsvRow),
                headers: UserCsvRow.generate_headers_line
              )
          end
        end
      end
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

#### Make commands

```bash
make b # Build
make d # Database
make l # Lint
make m # Migrate
make t # Test
```

#### Rake tasks

```bash
bundle exec rake spec
bundle exec rake rails[some_rails_task] # bundle exec rake rails[db:migrate]
bundle exec rake app:prepare
bundle exec rake app:setup
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
