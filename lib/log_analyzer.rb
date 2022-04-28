# frozen_string_literal: true

require_relative "log_analyzer/agent"
require_relative "log_analyzer/requests_info"

# Log file parser
module LogAnalyzer
  class FileNotReadableError < StandardError; end

  module Formatters
    autoload :PageViewsFormatter,     "log_analyzer/formatters/page_views_formatter"
    autoload :UniqPageViewsFormatter, "log_analyzer/formatters/uniq_page_views_formatter"
  end

  autoload :Parser,   "log_analyzer/parser"
  autoload :Orderers, "log_analyzer/orderers"
end
