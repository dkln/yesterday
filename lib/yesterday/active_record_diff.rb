module Yesterday
  class ActiveRecordDiff < Struct.new(:object, :from_version, :to_version)

    delegate :change_sets, :to => :object

    def version_number
      change_sets.last.version_number
    end

    def diff
      #Differ.new(last_changeset.object_attributes, prev
    end

    private

    def last_changeset
      @last_changeset ||= Yesterday::Changeset.last_for(object)
    end

    def previous_changeset
      @previous_changeset ||= Yesterday::Changeset.for_changed_object(object).order('created_at DESC').limit(2).last
    end

  end
end
