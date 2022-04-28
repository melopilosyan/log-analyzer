# frozen_string_literal: true

RSpec.describe LogAnalyzer::Orderers do
  let(:random) { [[:a, 5], [:b, 3], [:c, 7]] }

  describe "ASC" do
    it "sorts in ascending order" do
      ascending = [[:b, 3], [:a, 5], [:c, 7]]

      expect(random.sort(&LogAnalyzer::Orderers::ASC)).to eq(ascending)
    end
  end

  describe "DESC" do
    it "sorts in descending order" do
      descending = [[:c, 7], [:a, 5], [:b, 3]]

      expect(random.sort(&LogAnalyzer::Orderers::DESC)).to eq(descending)
    end
  end
end
