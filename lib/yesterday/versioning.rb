module Yesterday
  class Versioning
    class << self
      def create_changeset_for(object)
        Changeset.create :changed_object => object
      end

      def changesets_for(object)
        Changeset.for_changed_object(object)
      end

      def current_version_number_for(object)
        changesets_for(object).last.try(:version_number) || 0
      end

      def versioned_object_for(version_number, object)
        changeset_for(version_number, object).try(:object)
      end

      def diff_for(from_version_number, to_version_number, object)
        from_attributes = object_attributes_for(from_version_number, object)
        to_attributes   = object_attributes_for(to_version_number, object)
        diff            = Differ.new(from_attributes, to_attributes).diff

        VersionedObjectCreator.new(diff).to_object
      end

      private

      def changeset_for(version_number, object)
        Changeset.for_changed_object(object).version(version_number).first
      end

      def object_attributes_for(version_number, object)
        changeset_for(version_number, object).object_attributes
      end

    end
  end
end
