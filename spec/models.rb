class Contact < ActiveRecord::Base

  has_and_belongs_to_many :addresses

  tracks_changes

end

class Address < ActiveRecord::Base
end
