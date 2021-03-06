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

      def changeset_model
        @changeset_model
      end

      def changeset_klass
        changeset_model.classify.constantize
      end

      def track_changes(options = {})
        with = options[:with] || :changeset
        @changeset_model = with.to_s

        send :include, InstanceMethods
        after_save :serialize_current_state
        exclude_tracking_for :associations => with.to_s.pluralize.to_sym
      end

      def version(version_number)
        if object = first
          Versioning.versioned_object_for version_number, object
        end
      end

      def diff_version(from_version_number, to_version_number)
        if object = first
          Versioning.diff_for from_version_number, to_version_number, object
        end
      end

    end

    module InstanceMethods
      def changesets
        @changesets ||= Versioning.changesets_for(self)
      end

      def version_number
        @version_number ||= Versioning.current_version_number_for(self)
      end

      def previous_version_number
        @previous_version_number ||= (version_number > 1 ? version_number - 1 : version_number)
      end

      def version(version_number)
        @version ||= {}
        @version[version_number] ||= Versioning.versioned_object_for(version_number, self)
      end

      def diff_version(from_version_number, to_version_number)
        @diff_version ||= {}
        @diff_version[from_version_number] ||= {}
        @diff_version[from_version_number][to_version_number] ||= Versioning.diff_for(from_version_number, to_version_number, self)
      end

      private

      def serialize_current_state
        reload
        Versioning.create_changeset_for self
        invalidate_cached_versioning
      end

      def invalidate_cached_versioning
        cached_versioned_items.each { |item| instance_variable_set(:"@#{item}", nil) }
      end

      def cached_versioned_items
        %w(changesets version_number previous_version_number version diff_version)
      end

    end

  end
end
