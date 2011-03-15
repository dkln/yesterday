module Yesterday
  class VersionedAttribute < Struct.new(:diff)

    def current
      diff.last
    end

    def previous
      diff.first
    end

    def to_s
      current.to_s
    end

    def to_i
      current.to_i
    end

  end
end
