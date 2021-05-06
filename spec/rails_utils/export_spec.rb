# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsUtils::Export do
  class ExportUserRow < described_class::CsvRowDefinition
    column :username, header: "Username", no: 1
  end

  let(:definition) { ExportUserRow }

  subject do
    [].tap { |io| described_class.new(io).perform(iterator, headers: definition.generate_headers_line) }.join
  end

  before do
    create(:user, username: "User1")
    create(:user, username: "User2")
  end

  let(:result) do
    <<-CSV.strip_heredoc
      Username
      User1
      User2
    CSV
  end

  describe "basic iterator" do
    let(:iterator) { described_class::BasicIterator.new(User.all, definition) }

    it "generate csv correctly" do
      is_expected.to eq(result)
    end
  end

  describe "batch iterator" do
    let(:iterator) { described_class::BatchIterator.new(User.all, definition) }

    it "generate csv correctly" do
      is_expected.to eq(result)
    end
  end
end
