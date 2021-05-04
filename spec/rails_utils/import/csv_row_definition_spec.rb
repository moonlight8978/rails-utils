# frozen_string_literal: true

RSpec.describe RailsUtils::Import::CsvRowDefinition do
  describe ".parse" do
    class SampleBookCsv < described_class
      column :title, :string
      column :author, :string
      column :published_at, :date
      column :sales_volume, :integer
    end

    subject { SampleBookCsv.parse(row) }

    let(:row) { OpenStruct.new(data: %w[Depzai superdepzai 2020-12-01 200], no: 1) }

    it "returns new csv instance, which has correct data" do
      csv = subject

      expect(csv).to be_a(SampleBookCsv)
      expect(csv.title).to eq("Depzai")
      expect(csv.author).to eq("superdepzai")
      expect(csv.published_at).to eq("2020-12-01")
      expect(csv.sales_volume).to eq("200")
    end
  end

  skip "default values"

  describe "#to_attributes" do
    subject do
      csv = SampleBookCsv.new(title: "depzai", author: "depzaivler", published_at: "2020-12-01", sales_volume: "500")
      ActiveSupport::HashWithIndifferentAccess.new(csv.to_attributes)
    end

    it "cast data to correct type" do
      is_expected.to include(
        title: "depzai",
        author: "depzaivler",
        published_at: "2020-12-01".to_date,
        sales_volume: 500
      )
    end
  end
end
