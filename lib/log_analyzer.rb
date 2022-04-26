# frozen_string_literal: true

require_relative "log_analyzer/parser"
require_relative "log_analyzer/orderers"
require_relative "log_analyzer/requests_info"
require_relative "log_analyzer/formatters/uniq_page_views_formatter"

# Log file parser
class LogAnalyzer
  EMPTY_MSG = "The log is empty or does not match the expected format"

  class FileNotReadableError < StandardError; end

  attr_writer :formatter, :orderer

  def initialize(file_path,
                 formatter: Formatters::PageViewsFormatter,
                 orderer: Orderers::DESC,
                 parser: Parser)
    verify_readability!(file_path)

    @orderer = orderer
    @formatter = formatter

    @requests = parser.call file_path
  end

  def report
    result = @formatter.new(@orderer).format(@requests)
    return [EMPTY_MSG] if result.empty?

    result
  end

  private

  def verify_readability!(file_path)
    File.readable?(file_path) or raise FileNotReadableError, %(Can't read "#{file_path}" file)
  end
end
