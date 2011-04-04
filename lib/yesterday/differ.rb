module Yesterday
  class Differ < Struct.new(:from, :to)

    def diff
      @diff ||= diff_object(from, to)
    end

    private

    def ignored_attributes
      %w(updated_at created_at id _event)
    end

    def diff_object(from, to)
      diff = diff_attributes(from, to)

      diff.merge! diff_collection(from, to)

      diff_created_objects from, to, diff
      diff_destroyed_objects from, to, diff

      diff
    end

    def diff_attributes(from, to)
      diff = {}

      from.each do |attribute, old_value|
        if attribute == 'id'
          diff[attribute] = old_value

        elsif old_value.is_a?(Hash)
          diff[attribute] = diff_attributes(old_value, to[attribute] || {})

        elsif !old_value.is_a?(Array) && !ignored_attributes.include?(attribute)
          new_value = to[attribute]
          diff[attribute] = [old_value, new_value]
          diff['_event'] = 'modified' if old_value != new_value

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
            new_object = find_object(new_objects, old_object['id']) if new_objects

            if new_object
              diff[attribute] ||= []
              diff[attribute] << diff_object(old_object, new_object)
            end
          end
        end
      end

      diff
    end

    def diff_created_objects(from, to, diff)
      diff_object_creation from, to, 'created', diff
    end

    def diff_destroyed_objects(from, to, diff)
      diff_object_creation to, from, 'destroyed', diff
    end

    def diff_object_creation(from, to, event, diff)
      to.each do |attribute, to_objects|
        if to_objects.is_a? Array
          from_objects = from[attribute] || []

          to_objects.each do |to_object|
            from_object = find_object(from_objects, to_object['id'])

            unless from_object
              to_object['_event'] = event
              diff[attribute] ||= []
              diff[attribute] << to_object
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
