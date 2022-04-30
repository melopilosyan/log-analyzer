# frozen_string_literal: true

module LogAnalyzer
  module Builders
    # Builds the unique page views report from the list of RequestsInfo objects.
    class UniqViewsBuilder < TotalViewsBuilder
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
