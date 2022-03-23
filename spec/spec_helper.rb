# frozen_string_literal: true

require "log_analyzer"

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

FAKE_REQUESTS = [
  %w[/contact 722.247.931.582],
  %w[/about/2 555.576.836.194],
  %w[/about/2 555.576.836.194],
  %w[/about/2 200.017.277.774],
  %w[/home 200.017.277.774],
  %w[/contact 235.313.352.950]
].each_with_object({}) do |(path, ip), cache|
  cache[path] ||= LogAnalyzer::RequestsInfo.new path
  cache[path].add_request_from ip
end.values

PARSERISH = ->(_file_path) { FAKE_REQUESTS }
