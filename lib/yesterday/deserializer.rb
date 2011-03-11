require 'yesterday/historical_item'

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
        else
          attributes[attribute] = value
        end
      end

      Yesterday::HistoricalItem.new(attributes)
    end

  end
end
