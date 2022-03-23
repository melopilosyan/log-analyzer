# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe LogAnalyzer do
  context "with invalid log file" do
    it "raises FileNotReadableError if the file is unreadable" do
      expect { LogAnalyzer.new("invalid.file") }.to raise_error(LogAnalyzer::FileNotReadableError)
    end

    it "reports with EMPTY MSG" do
      analyzer = LogAnalyzer.new "spec/log_files/malformed.log"

      expect(analyzer.report).to eq([LogAnalyzer::EMPTY_MSG])
    end
  end

  context "with valid log file" do
    let(:log_file) { "spec/log_files/webserver.log" }
    let(:analyzer) { LogAnalyzer.new log_file }

    let(:views_formatter) { LogAnalyzer::Formatters::PageViewsFormatter }
    let(:uniq_formatter) { LogAnalyzer::Formatters::UniqPageViewsFormatter }
    let(:asc) { LogAnalyzer::Orderers::ASC }
    let(:desc) { LogAnalyzer::Orderers::DESC }

    context "with default parameters - PageViewsFormatter:DESC:Parser" do
      let(:report) { ["/about/2 3 visits", "/contact 2 visits", "/home 1 visits"] }

      it "works through constructor" do
        expect(analyzer.report).to eq(report)
      end

      it "works through attributes assignment" do
        analyzer.formatter = views_formatter
        analyzer.orderer = desc

        expect(analyzer.report).to eq(report)
      end
    end

    context "(with stubbed parser)" do
      let(:parser) { PARSERISH }
      let(:analyzer) { LogAnalyzer.new log_file, parser: }

      context "with PageViewsFormatter and ascending order" do
        let(:report) { ["/home 1 visits", "/contact 2 visits", "/about/2 3 visits"] }

        it "works through constructor" do
          analyzer = LogAnalyzer.new log_file,
                                     formatter: views_formatter,
                                     orderer: asc, parser: parser

          expect(analyzer.report).to eq(report)
        end

        it "works through attributes assignment" do
          analyzer.formatter = views_formatter
          analyzer.orderer = asc

          expect(analyzer.report).to eq(report)
        end
      end

      context "with UniqPageViewsFormatter and descending order" do
        let(:report) do
          ["/contact 2 unique views", "/about/2 2 unique views", "/home 1 unique views"]
        end

        it "works through constructor" do
          analyzer = LogAnalyzer.new log_file,
                                     formatter: uniq_formatter,
                                     orderer: desc, parser: parser

          expect(analyzer.report).to eq(report)
        end

        it "works through attributes assignment" do
          analyzer.formatter = uniq_formatter
          analyzer.orderer = desc

          expect(analyzer.report).to eq(report)
        end
      end

      context "with UniqPageViewsFormatter and ascending order" do
        let(:report) do
          ["/home 1 unique views", "/contact 2 unique views", "/about/2 2 unique views"]
        end

        it "works through constructor" do
          analyzer = LogAnalyzer.new log_file,
                                     formatter: uniq_formatter,
                                     orderer: asc, parser: parser

          expect(analyzer.report).to eq(report)
        end

        it "works through attributes assignment" do
          analyzer.formatter = uniq_formatter
          analyzer.orderer = asc

          expect(analyzer.report).to eq(report)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
