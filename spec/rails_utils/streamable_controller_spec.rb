# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsUtils::StreamableController, type: :request do
  before do
    create(:user, username: "a", is_admin: true)
    create(:user, username: "b", is_admin: false)
  end

  describe "stream csv" do
    subject { get "/users", params: { format: :csv } }

    it "respond with correct headers" do
      subject

      expect(response.headers["content-type"]).to include("csv")
      expect(response.headers["cache-control"]).to eq("no-cache")
      expect(response.headers["content-disposition"]).to include("users.csv")
    end

    it "respond with correct data" do
      subject

      _csv_header, *rows = CSV.parse(response.body)
      expect(rows[0]).to eq(%w[a Admin])
      expect(rows[1]).to eq(%w[b User])
    end
  end
end
