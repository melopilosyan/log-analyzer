# frozen_string_literal: true

RSpec.describe LogAnalyzer::Agent do
  subject { described_class.new log_path, orderer:, view_builder_class: }
  let(:log_path) { "spec/log_files/valid.log" }

  describe "#parse!" do
    let(:orderer) { LogAnalyzer::Orderers::DESC }
    let(:view_builder_class) { LogAnalyzer::Builders::TotalViewsBuilder }

    context "when log file is unreadable" do
      let(:log_path) { "invalid.file" }

      it "raises FileNotReadableError" do
        expect { subject.parse! }.to raise_error(LogAnalyzer::FileNotReadableError)
      end
    end

    context "with valid log file" do
      it "initializes @requests with array of RequestsInfo objects and returns self" do
        expect(subject.parse!).to be(subject)

        expect(subject.requests).to be_an(Array)
        expect(subject.requests.first).to be_a(LogAnalyzer::RequestsInfo)
      end
    end
  end

  describe "#analytics" do
    let(:analytics) { subject.parse!.analytics }

    context "in descending order" do
      let(:orderer) { LogAnalyzer::Orderers::DESC }

      context "by total page vews" do
        let(:view_builder_class) { LogAnalyzer::Builders::TotalViewsBuilder }

        it "generates the report" do
          expect(analytics)
            .to eq(["/about/12 3 visits", "/nested/contact 2 visits", "/home 1 visits"])
        end
      end

      context "by unique page vews" do
        let(:view_builder_class) { LogAnalyzer::Builders::UniqViewsBuilder }

        it "generates the report" do
          expected_data = [
            "/nested/contact 2 unique views", "/about/12 2 unique views", "/home 1 unique views"
          ]

          expect(analytics).to eq(expected_data)
        end
      end
    end

    context "in ascending order" do
      let(:orderer) { LogAnalyzer::Orderers::ASC }

      context "by total page vews" do
        let(:view_builder_class) { LogAnalyzer::Builders::TotalViewsBuilder }

        it "generates the report" do
          expect(analytics)
            .to eq(["/home 1 visits", "/nested/contact 2 visits", "/about/12 3 visits"])
        end
      end

      context "by unique page vews" do
        let(:view_builder_class) { LogAnalyzer::Builders::UniqViewsBuilder }

        it "generates the report" do
          expected_data = [
            "/home 1 unique views", "/nested/contact 2 unique views", "/about/12 2 unique views"
          ]

          expect(analytics).to eq(expected_data)
        end
      end
    end
  end
end
