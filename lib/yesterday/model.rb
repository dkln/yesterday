module Yesterday
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def ignore_tracking_for(options)
        if options[:associations]
          @not_tracked_associations ||= []
          @not_tracked_associations += Array(options[:associations]).map(&:to_s)
        end
      end

      def not_tracked_associations
        @not_tracked_associations
      end

      def tracks_changes(options = {})
        send :include, InstanceMethods

        after_save :serialize_current_state
        ignore_tracking_for :associations => :changesets
      end
    end

    module InstanceMethods
      def changesets
        Changeset.for_changed_object(self)
      end

      def version_number
        changesets.last.try(:version_number) || 0
      end

      private

      def previous_version_number
        version_number > 1 ? version_number - 1 : version_number
      end

      def serialize_current_state
        Changeset.create :changed_object => self
      end

    end

  end
end
