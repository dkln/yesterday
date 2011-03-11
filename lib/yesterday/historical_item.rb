module Yesterday
  class HistoricalItem < Struct.new(:attributes)

    def id
      attributes['id']
    end

    def method_missing(method, *arguments, &block)
      if attributes.has_key?(method.to_s)
        attributes[method.to_s]
      else
        super
      end
    end

  end
end
