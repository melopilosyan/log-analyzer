# frozen_string_literal: true

require_relative "log_analyzer/parser"
require_relative "log_analyzer/orderers"
require_relative "log_analyzer/requests_info"
require_relative "log_analyzer/formatters/uniq_page_views_formatter"

# Log file parser
class LogAnalyzer
  class FileNotReadableError < StandardError; end

  attr_reader :formatter, :parser, :requests

  def initialize(file_path,
                 formatter: Formatters::PageViewsFormatter,
                 orderer: Orderers::DESC,
                 parser: Parser)
    @parser = parser.new file_path
    @formatter = formatter.new orderer
  end

  # @raise FileNotReadableError
  def parse!
    verify_readability!

    @requests = parser.parse
    self
  end

  def analytics
    return [] if requests.empty?

    formatter.format requests
  end

  private

  def verify_readability!
    path = parser.file_path
    File.readable?(path) or raise FileNotReadableError, %(Can't read "#{path}" file)
  end
end
