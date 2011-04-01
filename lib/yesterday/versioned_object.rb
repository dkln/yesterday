module Yesterday
  class VersionedObject < Struct.new(:attributes)

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

    def modified?
      attributes['_event'] && attributes['_event'] == 'modified'
    end

    def created?
      attributes['_event'] && attributes['_event'] == 'created'
    end

    def destroyed?
      attributes['_event'] && attributes['_event'] == 'destroyed'
    end

    def unmodified?
      !attributes.has_key?('_event')
    end

  end

end
