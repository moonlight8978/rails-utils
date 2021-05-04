# frozen_string_literal: true

module RailsUtils
  class Export::BasicIterator
    attr_accessor :row_definition, :collection, :context

    def initialize(collection, row_definition, **context)
      self.collection = collection
      self.row_definition = row_definition
      self.context = context
    end

    def each
      collection.each do |record|
        yield row_definition.generate_line(record, context)
      end
    end
  end
end
