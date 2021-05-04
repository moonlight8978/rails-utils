module RailsUtils
  class Form
    include ActiveModel::Model
    include ActiveModel::Attributes

    class_attribute :attribute_names, default: [], instance_predicate: false, instance_accessor: false

    class << self
      def field(*args, **options)
        attribute *args, **options.except(:exclude)
        self.attribute_names = [*attribute_names, args[0]] unless options[:exclude]
      end
    end

    field :model, exclude: true

    def invalid?
      !valid?
    end

    def save
      return false unless valid?

      save_model
    end

    # TODO: Allow to change attribute key name
    def attributes
      self.class.attribute_names.map do |attr|
        type = self.class.attribute_types[attr.to_s]
        value = public_send(attr)
        [attr, type ? type.serialize(value) : value]
      end.to_h
    end

    private

    def save_model
      model.update(attributes)
      true
    end
  end
end
