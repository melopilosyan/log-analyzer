# frozen_string_literal: true

RSpec.shared_examples "a page views builder" do
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

  it "builds in ascending order" do
    builder = described_class.new LogAnalyzer::Orderers::ASC

    expect(builder.build_from(requests)).to eq(collection_asc)
  end

  it "builds in descending order" do
    builder = described_class.new LogAnalyzer::Orderers::DESC

    expect(builder.build_from(requests)).to eq(collection_desc)
  end
end

RSpec.describe LogAnalyzer::Builders::TotalViewsBuilder do
  it_behaves_like "a page views builder" do
    let(:collection_asc) { ["b 1 visits", "a 2 visits", "c 3 visits"] }
    let(:collection_desc) { ["c 3 visits", "a 2 visits", "b 1 visits"] }
  end
end

RSpec.describe LogAnalyzer::Builders::UniqViewsBuilder do
  it_behaves_like "a page views builder" do
    let(:collection_asc) { ["b 1 unique views", "a 2 unique views", "c 3 unique views"] }
    let(:collection_desc) { ["c 3 unique views", "a 2 unique views", "b 1 unique views"] }
  end
end
