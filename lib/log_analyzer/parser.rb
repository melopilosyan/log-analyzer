# frozen_string_literal: true

class LogAnalyzer
  # Parses given log file content into RequestsInfo objects
  class Parser
    LINE_FORMAT = %r{
      \A                        # Start of the string/line
      (/(?:\w+/?)+\d*)          # Request path
      \s+                       # Spaces
      (\d{3}.\d{3}.\d{3}.\d{3}) # Ip-ish
    }x

    attr_reader :file_path, :requests

    def initialize(file_path)
      @file_path = file_path
    end

    def parse
      File.open(file_path, "r") do |file|
        init_requests file
      end

      requests
    end

    private

    def init_requests(file)
      cache = file.each_line.with_object({}) do |line, hash|
        line.strip!
        next if line.empty?

        path, ip = line.match(LINE_FORMAT)&.values_at 1, 2
        next unless path && ip

        hash[path] ||= RequestsInfo.new path
        hash[path].add_request_from ip
      end

      @requests = cache.values
    end
  end
end
