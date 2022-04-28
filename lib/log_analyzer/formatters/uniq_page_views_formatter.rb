# frozen_string_literal: true

require_relative "page_views_formatter"

module LogAnalyzer
  module Formatters
    # Formats the unique page views report from the list of RequestsInfo objects.
    class UniqPageViewsFormatter < PageViewsFormatter
      private

      def visits_count(requests_info)
        requests_info.uniq_views
      end

      def stringify(path, visits_count)
        "#{path} #{visits_count} unique views"
      end
    end
  end
end
