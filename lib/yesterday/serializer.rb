module Yesterday
  class Serializer < Struct.new(:object)

    def to_hash
      @hash ||= hash_object(object)
    end

    private

    def hash_object(object)
      hash = {}
      hash.merge! object.attributes

      each_association_collection(object) do |association, association_name, item|
        path << object

        if assocation_has_collection?(association)
          hash[association_name] ||= []
          hash[association_name] << hash_object(item)
        else
          hash[association_name] = hash_object(item)
        end

        path.pop
      end

      hash
    end

    def assocation_has_collection?(association)
      [:has_many, :has_and_belongs_to_many].include? association.macro
    end

    def have_visited_object?(object)
      self.object == object || path.include?(object)
    end

    def each_association_collection(object)
      associations_for(object).each do |association|
        association_name = association.name.to_s

        association_collection(object, association_name).each do |item|
          yield(association, association_name, item) unless have_visited_object?(item)
        end
      end
    end

    def associations_for(object)
      associations = object.class.reflect_on_all_associations

      tracked_associations = object.class.respond_to?(:tracked_associations) ? object.class.tracked_associations : []
      ignored_associations = object.class.respond_to?(:not_tracked_associations) ? object.class.not_tracked_associations : []

      associations.select do |association|
        ( !ignored_associations.include?(association.name.to_s) &&
          ( tracked_associations.empty? ||
            tracked_associations.include?(association_name.to_s)) )
      end
    end

    def association_collection(object, association_name)
      object.send(association_name).to_a
    end

    def visited_objects
      @visited_objects ||= []
    end

    def path
      @path ||= []
    end

  end
end
