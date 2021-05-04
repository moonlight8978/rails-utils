# frozen_string_literal: true

RSpec.describe RailsUtils::Export do
  class ExportUserRow < described_class::CsvRowDefinition
    column :username, header: "Username", no: 1
  end

  let(:definition) { ExportUserRow }
  let(:iterator) { described_class::BasicIterator.new(User.all, definition) }

  subject do
    Array.new.tap { |io| described_class.new(io).perform(iterator, headers: definition.generate_headers_line) }.join
  end

  before do
    create(:user, username: "User1")
    create(:user, username: "User2")
  end

  it "generate csv correctly" do
    result = <<-CSV.strip_heredoc
      Username
      User1
      User2
    CSV
    is_expected.to eq(result)
  end
end
