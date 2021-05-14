# frozen_string_literal: true

RSpec.describe RailsUtils::Import::CsvRowDefinition do
  class SampleBookCsv < described_class
    column :title, :string
    column :author, :string
    column :published_at, :date
    column :sales_volume, :integer, default: -> { "0" }
    column :genre, :integer

    validates :published_at, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }, allow_blank: true
    validates :sales_volume, format: { with: /\A[0-9]{1,}\z/ }, allow_blank: true
    validates :genre, inclusion: { in: %w[1 2] }, allow_blank: true
  end

  describe ".parse" do
    subject { SampleBookCsv.parse(row) }

    let(:row) { OpenStruct.new(data: %w[Depzai superdepzai 2020-12-01 200 1], no: 1) }

    it "returns new csv instance, which has correct data" do
      csv = subject

      expect(csv).to be_a(SampleBookCsv)
      expect(csv.title).to eq("Depzai")
      expect(csv.author).to eq("superdepzai")
      expect(csv.published_at).to eq("2020-12-01")
      expect(csv.sales_volume).to eq("200")
      expect(csv.genre).to eq("1")
    end
  end

  describe "#to_attributes" do
    subject do
      row = SampleBookCsv.new(title: "depzai", author: "depzaivler", published_at: "2020-12-01", sales_volume: "500",
                              genre: "1")
      ActiveSupport::HashWithIndifferentAccess.new(row.to_attributes)
    end

    it "cast data to correct type" do
      is_expected.to include(
        title: "depzai",
        author: "depzaivler",
        published_at: "2020-12-01".to_date,
        sales_volume: 500,
        genre: 1
      )
    end
  end

  describe "default values" do
    subject { SampleBookCsv.new(sales_volume: "") }

    it "does not cast when attribute method called" do
      expect(subject.sales_volume).to eq("0")
    end

    it "cast default value correctly on #to_attributes" do
      parsed = ActiveSupport::HashWithIndifferentAccess.new(subject.to_attributes)
      expect(parsed).to include(sales_volume: 0)
    end
  end

  describe "validation" do
    subject do
      SampleBookCsv
        .new(genre: "3", published_at: "12-01-12", sales_volume: "xxx")
        .tap(&:valid?)
        .errors
        .full_messages
    end

    it "validates correctly with original input value" do
      is_expected.to match_array(
        [
          "Published at is invalid",
          "Genre is not included in the list",
          "Sales volume is invalid"
        ]
      )
    end
  end
end
