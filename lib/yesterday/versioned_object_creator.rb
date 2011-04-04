module Yesterday
  class VersionedObjectCreator < Struct.new(:hash)

    def to_object
      @object ||= deserialize(hash)
    end

    private

    def deserialize(hash)
      attributes = {}

      hash.each do |attribute, value|
        if contains_nested_objects? value
          value.each do |item|
            attributes[attribute] ||= []
            attributes[attribute] << deserialize(item) if item
          end

        elsif contains_nested_object? value
          attributes[attribute] = deserialize(value)

        elsif attribute != 'id'
          attributes[attribute] = value.is_a?(Array) ? Yesterday::VersionedAttribute.new(value) : value

        end
      end

      Yesterday::VersionedObject.new(attributes.merge({ 'id' => hash['id']}))
    end

    def contains_nested_objects?(value)
      value.is_a?(Array) && value.first.is_a?(Hash)
    end

    def contains_nested_object?(value)
      value.is_a?(Hash)
    end

  end
end
