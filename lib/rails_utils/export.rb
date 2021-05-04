# frozen_string_literal: true

module RailsUtils
  class Export
    attr_accessor :context, :io

    def initialize(io)
      self.io = io
    end

    def perform(iterator, headers: nil, after: proc { 1 })
      io << headers if headers

      iterator.each do |csv_lines|
        Array(csv_lines).each { |line| io << line }
      end

      after.call(iterator)
    end
  end
end
