# frozen_string_literal: true

module LogAnalyzer
  # The coordinator class.
  # Performs file validation & parsing and analytics generation.
  class Agent
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
end
