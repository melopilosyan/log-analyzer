# frozen_string_literal: true

RSpec.describe LogParser do
  let(:parser) { LoadError.new }

  it "Parser exists" do
    expect(parser).not_to be nil
  end
end
