module Yesterday
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def exclude_tracking_for(options)
        if options[:associations]
          @excluded_tracked_associations ||= []
          @excluded_tracked_associations += Array(options[:associations]).map(&:to_s)
        end

        if options[:attributes]
          @excluded_tracked_attributes ||= []
          @excluded_tracked_attributes += Array(options[:attributes]).map(&:to_s)
        end
      end

      def include_tracking_for(options)
        if options[:associations]
          @tracked_associations ||= []
          @tracked_associations += Array(options[:associations]).map(&:to_s)
        end

        if options[:attributes]
          @tracked_attributes ||= []
          @tracked_attributes += Array(options[:attributes]).map(&:to_s)
        end
      end

      def excluded_tracked_associations
        @excluded_tracked_associations || []
      end

      def excluded_tracked_attributes
        @excluded_tracked_attributes || []
      end

      def tracked_associations
        @tracked_associations || []
      end

      def tracked_attributes
        @tracked_attributes || []
      end

      def tracks_changes(options = {})
        send :include, InstanceMethods

        after_save :serialize_current_state
        exclude_tracking_for :associations => :changesets
      end

      def version(version_number)
        if object = first
          find_version_for(version_number, object)
        end
      end

      private

      def find_version_for(version_number, object)
        Changeset.for_changed_object(object).version(version_number).first.try(:object)
      end

    end

    module InstanceMethods
      def changesets
        Changeset.for_changed_object(self)
      end

      def version_number
        changesets.last.try(:version_number) || 0
      end

      def version(version_number)
        self.class.send(:find_version_for, version_number, self)
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
