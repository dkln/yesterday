require 'yesterday/historical_item'
require 'yesterday/historical_value'

module Yesterday
  class Deserializer < Struct.new(:diff)

    def to_object
      @object ||= deserialize(diff)
    end

    private

    def deserialize(diff)
      attributes = {}

      diff.each do |attribute, value|
        if value.is_a?(Array) && value.first.is_a?(Hash)
          value.each do |item|
            attributes[attribute] ||= []
            attributes[attribute] << deserialize(item)
          end

        elsif attribute != 'id'
          attributes[attribute] = Yesterday::HistoricalValue.new(value)
        end
      end

      Yesterday::HistoricalItem.new(attributes.merge({ 'id' => diff['id']}))
    end

  end
end
