# frozen_string_literal: true

RSpec.describe LogAnalyzer::RequestsInfo do
  let(:requests_info) { described_class.new "/path" }

  describe "#initialize" do
    it "sets the initial state" do
      expect(requests_info.path).to eq("/path")
      expect(requests_info.total_views).to be(0)
      expect(requests_info.uniq_views).to be(0)
    end
  end

  describe "#add_request_from" do
    it "increments views counts" do
      requests_info.add_request_from "4.4.4.4"

      expect(requests_info.total_views).to be(1)
      expect(requests_info.uniq_views).to be(1)
    end

    it "handles uniq views" do
      requests_info.add_request_from "4.4.4.4"
      requests_info.add_request_from "4.4.4.4"

      expect(requests_info.total_views).to be(2)
      expect(requests_info.uniq_views).to be(1)
    end

    it "handles multiple different views" do
      requests_info.add_request_from "4.4.4.4"
      requests_info.add_request_from "4.4.4.4"
      requests_info.add_request_from "1.1.1.1"

      expect(requests_info.total_views).to be(3)
      expect(requests_info.uniq_views).to be(2)
    end
  end
end
