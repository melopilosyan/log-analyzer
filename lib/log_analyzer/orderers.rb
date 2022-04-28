# frozen_string_literal: true

module LogAnalyzer
  module Orderers
    ASC = ->(a, b) { a.last - b.last }
    DESC = ->(a, b) { b.last - a.last }
  end
end
