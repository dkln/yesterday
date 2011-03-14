module Yesterday
  module Model

    def self.included(base)
      base.after_save :serialize_current_state
      base.extend ClassMethods
    end

    private

    def serialize_current_state
      self.reload
    end

    module ClassMethods
      def tracks_changes
      end
    end

  end
end
