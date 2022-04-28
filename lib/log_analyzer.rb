# frozen_string_literal: true

require_relative "log_analyzer/agent"
require_relative "log_analyzer/parser"
require_relative "log_analyzer/orderers"
require_relative "log_analyzer/requests_info"
require_relative "log_analyzer/formatters/uniq_page_views_formatter"

# Log file parser
module LogAnalyzer
  class FileNotReadableError < StandardError; end
end
