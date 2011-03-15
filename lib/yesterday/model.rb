module Yesterday
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def tracks_changes(options = {})
        send :include, InstanceMethods

        has_many :change_sets, :order => 'created_at DESC'

        after_save :serialize_current_state
      end
    end

    module InstanceMethods
      def version_number
        change_sets.last.version_number
      end

      def compare_with_version(version_number)
      end

      def previous_version

      end

      private


      def previous_version_number
        version_number > 1 ? version_number - 1 : version_number
      end

    end

  end
end
