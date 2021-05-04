module RailsUtils
  class Import
    Row = Struct.new("Row", :no, :data, keyword_init: true)

    def perform(csv_file, processor = Csvs::Import::RowProcessors::Basic.new, after: proc {})
      index = 1
      # TODO: Handle invalid csv errors
      ActiveRecord::Base.transaction do
        ::CSV.foreach(csv_file, encoding: "utf-8", headers: true) do |row|
          processor.call(Row.new(no: index, data: row))
          index += 1
        end

        # Use other errors
        raise ArgumentError, processor.errors.join("\n") if processor.errors.any?

        after.call(processor)
      end
    end
  end
end
