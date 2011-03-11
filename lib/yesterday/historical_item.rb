module Yesterday
  class HistoricalItem < Struct.new(:attributes)

    def id
      attributes['id']
    end

    def new_value_for(attribute)
      attributes[attribute.to_s].is_a?(Array) ? attributes[attribute.to_s].last : attributes[attribute.to_s]
    end

    def old_value_for(attribute)
      attributes[attribute.to_s].is_a?(Array) ? attributes[attribute.to_s].first : attributes[attribute.to_s]
    end

    def method_missing(method, *arguments, &block)
      if attributes.has_key?(method.to_s)
        new_value_for method
      else
        super
      end
    end

  end
end
