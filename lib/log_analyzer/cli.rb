# frozen_string_literal: true

require "optparse"

module LogAnalyzer
  # Defines command line interface for the executable script
  class Cli
    EMPTY_MSG = "The log is empty or does not match the expected format"

    def self.invoke
      analytics = new(ARGV).invoke

      analytics = EMPTY_MSG if analytics.empty?

      puts
      puts analytics
    end

    def initialize(argv)
      @argv = argv
      @params_parser = ParamsParser.new
    end

    def invoke
      params = @params_parser.parse @argv

      analyzer = Agent.new params.log_file,
                           orderer: params.orderer,
                           view_builder_class: params.view_builder_class

      analyzer.parse!.analytics.join "\n"
    rescue FileNotReadableError, OptionParser::MissingArgument => e
      e.message
    end

    # Configures/runs OptionsParser and stores given parameters
    class ParamsParser
      DESCRIPTION = <<~DESC.strip
        Parse the log file given as LOG_FILE_PATH.
        Output the list of paths to WEB pages with total views counts(option value: TV)
        Or with unique page views counts(option value: UV).
        Order results by counts in ascending(opt: ASC) or descending(opt: DESC) order.

        Options:
      DESC

      attr_accessor :order, :format, :log_file

      def initialize
        @opts = OptionParser.new

        declare_script_usage
        declare_format_option
        declare_order_option
        declare_help_option
      end

      def parse(argv)
        opts.parse! argv

        unless (self.log_file = argv[0])
          puts opts
          exit
        end

        self
      end

      def view_builder_class
        format == "UV" ? Builders::UniqViewsBuilder : Builders::TotalViewsBuilder
      end

      def orderer
        order == "ASC" ? Orderers::ASC : Orderers::DESC
      end

      private

      attr_reader :opts

      def declare_script_usage
        opts.banner = "Usage: ./parser [OPTIONS]... LOG_FILE_PATH"
        opts.separator ""
        opts.separator DESCRIPTION
      end

      def declare_format_option
        opts.on("-f", "--format FORMAT", "select the output format - TV or UV - default TV") do |f|
          self.format = f
        end
      end

      def declare_order_option
        opts.on("-o", "--order ORDER", "specify results order - default DESC") do |o|
          self.order = o
        end
      end

      def declare_help_option
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end
    end
  end
end
