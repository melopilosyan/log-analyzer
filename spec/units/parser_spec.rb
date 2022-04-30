# frozen_string_literal: true

RSpec.describe LogAnalyzer::Parser do
  subject { described_class.new file_path }

  describe "#initialize" do
    let(:file_path) { "file.path" }

    it "assignes the .file_path" do
      expect(subject.file_path).to eq(file_path)
    end
  end

  describe "#parse" do
    context "with valid logs" do
      let(:file_path) { "spec/log_files/valid.log" }

      it "returns array of RequestsInfo objects" do
        expect(subject.parse.all? { |r| r.instance_of? LogAnalyzer::RequestsInfo }).to be(true)
      end

      it "builds RequestsInfo objects with correct data" do
        data = subject.parse.map { |r| [r.path, r.total_views, r.uniq_views] }
        expected_data = [["/nested/contact", 2, 2], ["/about/12", 3, 2], ["/home", 1, 1]]

        expect(data).to eq(expected_data)
      end
    end

    context "with full malformed logs" do
      let(:file_path) { "spec/log_files/malformed.log" }

      it "returns empty array" do
        expect(subject.parse).to eq([])
      end
    end

    context "with semi valid logs" do
      let(:file_path) { "spec/log_files/semi_valid.log" }

      it "takes lines only with appropriate format" do
        expect(subject.parse.map(&:path)).to eq(["/user/791", "/home"])
      end
    end
  end
end
