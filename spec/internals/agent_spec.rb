# frozen_string_literal: true

RSpec.describe LogAnalyzer::Agent do
  describe "#initialize" do
    it "instantiates the formatter & parser" do
      analyzer = described_class.new "file.path"

      expect(analyzer.parser).to be_a(LogAnalyzer::Parser)
      expect(analyzer.formatter).to be_a(LogAnalyzer::Formatters::PageViewsFormatter)
    end
  end

  describe "#parse!" do
    context "when log file is unreadable" do
      it "raises FileNotReadableError" do
        expect do
          described_class.new("invalid.file").parse!
        end.to raise_error(LogAnalyzer::FileNotReadableError)
      end
    end

    context "with valid log file" do
      it "initializes @requests with array of RequestsInfo objects and returns self" do
        analyzer = described_class.new VALID_LOG_PATH

        expect(analyzer.parse!).to be(analyzer)

        expect(analyzer.requests).to be_an(Array)
        expect(analyzer.requests.first).to be_a(LogAnalyzer::RequestsInfo)
      end
    end
  end

  describe "#analytics" do
    it "returns formatted & ordered list of log analytics" do
      analytics = described_class.new(
        VALID_LOG_PATH,
        formatter: LogAnalyzer::Formatters::UniqPageViewsFormatter,
        orderer: LogAnalyzer::Orderers::ASC
      ).parse!.analytics

      expected_data = [
        "/home 1 unique views", "/nested/contact 2 unique views", "/about/12 2 unique views"
      ]

      expect(analytics).to eq(expected_data)
    end
  end
end
