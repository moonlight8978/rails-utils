# frozen_string_literal: true

module RailsUtils
  class Import::CsvRowDefinition
    include ActiveModel::Model
    include ActiveModel::Attributes

    class_attribute :types, default: {}, instance_predicate: false, instance_accessor: false
    class_attribute :model_class, instance_predicate: false
    class_attribute :virtual_attribute_names, default: [], instance_predicate: false, instance_accessor: false

    class << self
      def column(name, type = ActiveModel::Type::Value.new, **options)
        attribute name, default: options[:default], type: :string
        type = ActiveModel::Type.lookup(type, **options.except(:default, :no)) if type.is_a?(Symbol)
        self.types = types.merge(name.to_s => type)
      end

      def parse(row, **_context)
        attributes = attribute_names.map.with_index do |attribute_name, index|
          [attribute_name, row.data[index]]
        end.to_h

        new(**attributes, no: row.no)
      end

      def model(class_name)
        self.model_class = class_name
      end

      def virtual(name)
        attr_accessor name
      end
    end

    virtual :no

    def initialize(*)
      super
      @attributes.keys.each do |attribute| # rubocop:disable Style/HashEachMethods
        default_value = self.class._default_attributes[attribute]
        next unless default_value

        send(:"#{attribute}=", send(attribute).presence || default_value.value)
      end
    end

    def to_attributes
      self.class.attribute_names.map do |attribute_name|
        [attribute_name, self.class.types[attribute_name].serialize(public_send(attribute_name))]
      end.to_h
    end

    def error_messages
      errors.full_messages.map { |message| "Row #{no}: #{message}" }
    end
  end
end
