module Yesterday
  class Changeset < ActiveRecord::Base

    before_create :determine_version_number, :determine_object_attributes
    belongs_to :changed_object

    serialize :object_attributes

    def self.for_changed_object(object)
      where(:changed_object_type => object.class.to_s, :changed_object_id => object.id)
    end

    def self.last_for(object)
      for_changed_object(object).order('created_at DESC').first
    end

    def self.version_number_for(object)
      last_for(object).try(:version_number) || 0
    end

    private

    def determine_version_number
      self.version_number = version_number_for(changed_object) + 1
    end

    def determine_object_attributes
      self.object_attributes = Yesterday::Serializer.new(changed_object).to_hash
    end

  end
end
