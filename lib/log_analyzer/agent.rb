# frozen_string_literal: true

module LogAnalyzer
  # The coordinator class.
  # Performs file validation & parsing and analytics generation.
  class Agent
    attr_reader :requests

    def initialize(file_path, view_builder_class:, orderer:, parser_class: Parser)
      @parser = parser_class.new file_path
      @view_builder = view_builder_class.new orderer
    end

    # @raise FileNotReadableError
    def parse!
      verify_readability!

      @requests = parser.parse
      self
    end

    def analytics
      return [] if requests.empty?

      view_builder.build_from requests
    end

    private

    attr_reader :view_builder, :parser

    def verify_readability!
      path = parser.file_path
      File.readable?(path) or raise FileNotReadableError, %(Can't read "#{path}" file)
    end
  end
end
