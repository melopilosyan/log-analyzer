# frozen_string_literal: true

module LogAnalyzer
  # Parses given log file content into RequestsInfo objects
  class Parser
    LINE_FORMAT = %r{
      \A                        # Start of the string/line
      (/(?:\w+/?)+\d*)          # Request path
      \s+                       # Spaces
      (\d{3}.\d{3}.\d{3}.\d{3}) # Ip-ish
    }x

    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def parse
      file = File.open file_path, "r"

      build_requests file
    ensure
      file.close
    end

    private

    def build_requests(file)
      cache = file.each_line.with_object({}) do |line, hash|
        line.strip!
        next if line.empty?

        path, ip = line.match(LINE_FORMAT)&.values_at 1, 2
        next unless path && ip

        hash[path] ||= RequestsInfo.new path
        hash[path].add_request_from ip
      end

      cache.values
    end
  end
end
