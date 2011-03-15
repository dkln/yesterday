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

      def historical_data_for(version_number, object)
        Changeset.for_changed_object(object).version(version_number).first.try(:object)
      end

      def find_diff_version_for(from_version_number, to_version_number, object)
        from_version = find_version_for(from_version_number, object)
        to_version   = find_version_for(to_version_number, object)


      end
    end
  end
end
