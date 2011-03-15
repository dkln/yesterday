module Yesterday
  class VersionedObjectCreator < Struct.new(:hash)

    def to_object
      @object ||= deserialize(hash)
    end

    private

    def deserialize(hash)
      attributes = {}

      hash.each do |attribute, value|
        if nested_value? value
          value.each do |item|
            attributes[attribute] ||= []
            attributes[attribute] << deserialize(item)
          end

        elsif attribute != 'id'
          attributes[attribute] = value.is_a?(Array) ? Yesterday::VersionedAttribute.new(value) : value
        end
      end

      Yesterday::VersionedObject.new(attributes.merge({ 'id' => hash['id']}))
    end

    def nested_value?(value)
      value.is_a?(Array) && value.first.is_a?(Hash)
    end

  end
end
