module Yesterday
  module Model

    def self.included(base)
      base.after_save :serialize_current_state
    end

    private

    def serialize_current_state

    end

  end
end
