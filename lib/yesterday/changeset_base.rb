module Yesterday
  module ChangesetBase

    def self.included(base)
      base.extend ClassMethods
      base.before_create :determine_version_number, :determine_object_attributes
      base.belongs_to :changed_object, :polymorphic => true
      base.serialize :object_attributes
    end

    def object
      @object ||= VersionedObjectCreator.new(object_attributes).to_object if object_attributes.present?
    end

    def made_changes
      unless @made_changes
        compare_version_number ||= version_number > 1 ? (version_number - 1) : 1

        from_attributes   = Versioning.changeset_for(compare_version_number, changed_object).object_attributes
        to_attributes     = object_attributes
        diff              = Differ.new(from_attributes, to_attributes).diff

        @made_changes = VersionedObjectCreator.new(diff).to_object
      end

      @made_changes
    end

    private

    def determine_version_number
      self.version_number = self.class.version_number_for(changed_object) + 1
    end

    def determine_object_attributes
      self.object_attributes = Yesterday::Serializer.new(changed_object).to_hash
    end


    module ClassMethods
      def version(version_number)
        where(:version_number => version_number)
      end

      def for_changed_object(object)
        where(:changed_object_type => object.class.to_s, :changed_object_id => object.id)
      end

      def last_for(object)
        for_changed_object(object).order('created_at DESC').first
      end

      def version_number_for(object)
        last_for(object).try(:version_number) || 0
      end
    end

  end
end
