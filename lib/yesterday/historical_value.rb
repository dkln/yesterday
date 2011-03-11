module Yesterday

  class HistoricalValue < Struct.new(:diff)

    def current
      diff.last
    end

    def previous
      diff.first
    end

    def to_s
      current
    end

    def to_i
      current
    end

  end

end
