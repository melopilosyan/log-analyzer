# frozen_string_literal: true

module LogAnalyzer
  module Formatters
    # Formats the page views report from the list of RequestsInfo objects.
    class PageViewsFormatter
      def initialize(orderer)
        @orderer = orderer
      end

      def format(requests)
        requests
          .map { |ri| [ri.path, visits_count(ri)] }
          .sort!(&@orderer)
          .map { |path, visits_count| stringify(path, visits_count) }
      end

      private

      def visits_count(requests_info)
        requests_info.total_views
      end

      def stringify(path, visits_count)
        "#{path} #{visits_count} visits"
      end
    end
  end
end
