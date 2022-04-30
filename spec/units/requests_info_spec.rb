# frozen_string_literal: true

RSpec.describe LogAnalyzer::RequestsInfo do
  subject { described_class.new "/path" }

  describe "#initialize" do
    it "sets the initial state" do
      expect(subject.path).to eq("/path")
      expect(subject.total_views).to be(0)
      expect(subject.uniq_views).to be(0)
    end
  end

  describe "#add_request_from" do
    it "increments views counts" do
      subject.add_request_from "4.4.4.4"

      expect(subject.total_views).to be(1)
      expect(subject.uniq_views).to be(1)
    end

    it "handles uniq views" do
      subject.add_request_from "4.4.4.4"
      subject.add_request_from "4.4.4.4"

      expect(subject.total_views).to be(2)
      expect(subject.uniq_views).to be(1)
    end

    it "handles multiple different views" do
      subject.add_request_from "4.4.4.4"
      subject.add_request_from "4.4.4.4"
      subject.add_request_from "1.1.1.1"

      expect(subject.total_views).to be(3)
      expect(subject.uniq_views).to be(2)
    end
  end
end
