# frozen_string_literal: true

RSpec.shared_examples "a RequestsInfo formatter" do
  let(:requests) do
    [
      [:a, "x"],
      [:b, "y"],
      [:a, "z"],
      [:c, "x"],
      [:c, "z"],
      [:c, "y"]
    ].each_with_object({}) do |(f, l), cache|
      cache[f] ||= LogAnalyzer::RequestsInfo.new f
      cache[f].add_request_from l
    end.values
  end

  it "formats in ascending order" do
    formatter = described_class.new LogAnalyzer::Orderers::ASC

    expect(formatter.format(requests)).to eq(formated_asc)
  end

  it "formats in descending order" do
    formatter = described_class.new LogAnalyzer::Orderers::DESC

    expect(formatter.format(requests)).to eq(formated_desc)
  end
end

RSpec.describe LogAnalyzer::Formatters::PageViewsFormatter do
  it_behaves_like "a RequestsInfo formatter" do
    let(:formated_asc) { ["b 1 visits", "a 2 visits", "c 3 visits"] }
    let(:formated_desc) { ["c 3 visits", "a 2 visits", "b 1 visits"] }
  end
end

RSpec.describe LogAnalyzer::Formatters::UniqPageViewsFormatter do
  it_behaves_like "a RequestsInfo formatter" do
    let(:formated_asc) { ["b 1 unique views", "a 2 unique views", "c 3 unique views"] }
    let(:formated_desc) { ["c 3 unique views", "a 2 unique views", "b 1 unique views"] }
  end
end
