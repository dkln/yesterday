module Yesterday
  class Differ < Struct.new(:from, :to)

    def diff
      @diff ||= diff_object(from, to)
    end

    private

    def diff_object(from, to)
      diff = diff_attributes(from, to)

      diff.merge! diff_collection(from, to)
      diff.merge! diff_created_objects(from, to)
      diff.merge! diff_destroyed_objects(from, to)

      diff
    end

    def diff_attributes(from, to)
      diff = {}

      from.each do |attribute, old_value|
        if attribute == 'id'
          diff[attribute] = old_value
        elsif !old_value.is_a?(Array)
          new_value = to[attribute]
          diff[attribute] = [old_value, new_value]
        end
      end

      diff
    end

    def diff_collection(from, to)
      diff = {}

      from.each do |attribute, old_objects|
        if old_objects.is_a? Array
          new_objects = to[attribute]

          old_objects.each do |old_object|
            new_object = find_object(new_objects, old_object['id'])

            if new_object
              diff[attribute] ||= []
              diff[attribute] << diff_object(old_object, new_object)
            end
          end
        end
      end

      diff
    end

    def diff_created_objects(from, to)
      diff_object_creation from, to, 'created'
    end

    def diff_destroyed_objects(from, to)
      diff_object_creation to, from, 'destroyed'
    end

    def diff_object_creation(from, to, event)
      diff = {}

      to.each do |attribute, to_objects|
        if to_objects.is_a? Array
          from_objects = from[attribute] || []

          to_objects.each do |to_object|
            from_object = find_object(from_objects, to_object['id'])

            unless from_object
              diff["#{event}_#{attribute}"] ||= []
              diff["#{event}_#{attribute}"] << to_object
            end
          end
        end
      end

      diff
    end

    def find_object(array, id)
      index = array.find_index { |object| object['id'] == id }
      array[index] if index
    end

    def is_same_object?(from, to)
      from['id'] == to['id']
    end

    def has_collection?(value)
      value.is_a? Array
    end

  end
end
