# frozen_string_literal: true

module RailsUtils
  class Import::BasicProcessor
    attr_accessor :row_definition, :context

    def initialize(row_definition, **context)
      self.row_definition = row_definition
      self.context = context
    end

    def errors
      @errors ||= []
    end

    def call(row_data)
      row = row_definition.parse(row_data, **context)
      model =
        begin
          row_definition.model_class.new(row.to_attributes, **context)
        rescue StandardError # TODO: Rescue argument errors only
          row_definition.model_class.new(row.to_attributes)
        end
      return if row.valid? && model.save # TODO: Catch other #save errors

      row.errors.merge!(model.errors)
      errors.concat(row.error_messages)
    end
  end
end
