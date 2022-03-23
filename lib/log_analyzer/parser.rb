# frozen_string_literal: true

class LogAnalyzer
  # Parses given log file content into RequestsInfo objects
  module Parser
    LINE_FORMAT = %r/\A(\/\w+\/?(\d+)?)\s(\d+{3}\.\d+{3}\.\d+{3}\.\d+{3})/

    class << self
      def call(file_path)
        requests = nil
        File.open(file_path, "r") { |file| requests = parse file }
        requests
      end

      def parse(file)
        cache = {}

        file.each_line do |line|
          line.strip!
          next if line.empty?

          request_path, ip = line.match(LINE_FORMAT)&.values_at 1, 3
          next unless request_path

          cache[request_path] ||= RequestsInfo.new request_path
          cache[request_path].add_request_from ip
        end

        cache.values
      end
    end
  end
end
