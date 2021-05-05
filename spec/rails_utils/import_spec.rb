# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsUtils::Import do
  class ImportCsvUserRow < described_class::CsvRowDefinition
    model User

    column :username, :string, no: 1
    column :is_admin, :boolean, no: 2, default: "0"

    validates :username, presence: true
    validates :is_admin, presence: true
    validates :is_admin, inclusion: %w[0 1], allow_blank: true
  end

  let(:definition) { ImportCsvUserRow }
  let(:row_proccessor) { RailsUtils::Import::BasicProcessor.new(definition) }

  subject { described_class.new.perform(csv_file, row_proccessor) }

  context "when import success" do
    let(:csv_file) { file_fixture("valid_users.csv") }

    it "creates new records with default values" do
      subject

      expect(User.count).to eq(2)

      user1, user2 = User.all

      expect(user1.username).to eq("test1")
      expect(user1.is_admin).to eq(true)

      expect(user2.username).to eq("test2")
      expect(user2.is_admin).to eq(false)
    end
  end

  context "when import failed" do
    let(:csv_file) { file_fixture("invalid_users.csv") }

    it "does not create new records and raises errors" do
      error =
        begin
          subject
        rescue StandardError => e
          e.message
        end

      expect(User.count).to eq(0)
      expect(error).to eq("Row 1: Username can't be blank\nRow 2: Is admin is not included in the list")
    end
  end
end
