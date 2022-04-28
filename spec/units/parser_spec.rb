# frozen_string_literal: true

RSpec.describe LogAnalyzer::Parser do
  it "initializes with given file path" do
    file_path = "file.path"
    parser = described_class.new file_path

    expect(parser.file_path).to eq(file_path)
  end

  describe "#parse" do
    context "with valid logs" do
      let(:requests) { described_class.new(VALID_LOG_PATH).parse }

      it "returns array of RequestsInfo objects" do
        expect(requests.all? { |r| r.instance_of? LogAnalyzer::RequestsInfo }).to be(true)
      end

      it "builds RequestsInfo objects with correct data" do
        data = requests.map { |r| [r.path, r.total_views, r.uniq_views] }
        expected_data = [["/nested/contact", 2, 2], ["/about/12", 3, 2], ["/home", 1, 1]]

        expect(data).to eq(expected_data)
      end
    end

    context "with malformed logs" do
      it "returns empty array" do
        requests = described_class.new(MALFORMED_LOG_PATH).parse

        expect(requests).to eq([])
      end

      it "takes lines only with appropriate format" do
        requests = described_class.new("spec/log_files/semi_valid.log").parse

        expect(requests.map(&:path)).to eq(["/user/791", "/home"])
      end
    end
  end
end
