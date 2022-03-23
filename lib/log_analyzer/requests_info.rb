# frozen_string_literal: true

require "set"

class LogAnalyzer
  # Stores information about visits to a specific request path.
  class RequestsInfo
    attr_reader :path, :total_views

    def initialize(path)
      @path = path
      @total_views = 0

      @uniq_ips = Set.new
    end

    def add_request_from(ip)
      @uniq_ips << ip
      @total_views += 1
    end

    def uniq_views
      @uniq_ips.count
    end
  end
end
