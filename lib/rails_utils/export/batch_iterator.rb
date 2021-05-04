module RailsUtils
  class Export::BatchIterator
    attr_accessor :row_definition, :collection, :context, :batch_size

    def initialize(collection, row_definition, batch_size: 1000, **context)
      self.collection = collection
      self.row_definition = row_definition
      self.context = context
      self.batch_size = batch_size
    end

    def each
      collection.find_each(batch_size: batch_size) do |record|
        yield row_definition.generate_line(record, context)
      end
    end
  end
end
