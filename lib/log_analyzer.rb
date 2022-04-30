# frozen_string_literal: true

lib = File.expand_path(".", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "log_analyzer/agent"
require "log_analyzer/requests_info"

# Log file parser
module LogAnalyzer
  class FileNotReadableError < StandardError; end

  module Builders
    autoload :TotalViewsBuilder, "log_analyzer/builders/total_views_builder"
    autoload :UniqViewsBuilder,  "log_analyzer/builders/uniq_views_builder"
  end

  autoload :Parser,   "log_analyzer/parser"
  autoload :Orderers, "log_analyzer/orderers"

  autoload :Cli,      "log_analyzer/cli"
end
