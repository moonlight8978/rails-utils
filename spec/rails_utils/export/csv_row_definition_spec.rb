# frozen_string_literal: true

RSpec.describe RailsUtils::Export::CsvRowDefinition do
  class SimpleUserExportCsv < described_class
    format_with :date do |date|
      date.strftime("%Y-%m-%d") if date.present?
    end

    column :username, header: "Username", no: 1
    column :is_admin, header: "Role", no: 2 do |user|
      user.is_admin ? "Admin" : "User"
    end
    column :created_at, header: "Registration date", format_with: :date, no: 3
  end

  describe ".generate_line" do
    subject do
      SimpleUserExportCsv.generate_line(
        build(:user, username: "a", is_admin: true, created_at: Date.new(2020, 12, 12)),
        {}
      )
    end

    it "returns csv line" do
      is_expected.to eq("a,Admin,2020-12-12\n")
    end
  end

  describe ".generate_headers_line" do
    subject { SimpleUserExportCsv.generate_headers_line }

    it "cast data to correct type" do
      is_expected.to eq("Username,Role,Registration date\n")
    end
  end
end
