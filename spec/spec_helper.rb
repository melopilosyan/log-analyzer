# frozen_string_literal: true

require "log_analyzer"

VALID_LOG_PATH = "spec/log_files/valid.log"
MALFORMED_LOG_PATH = "spec/log_files/malformed.log"

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
