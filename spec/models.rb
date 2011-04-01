class Contact < ActiveRecord::Base
  has_and_belongs_to_many :addresses
  track_changes
end

class Address < ActiveRecord::Base
end

class Company < ActiveRecord::Base
  track_changes
  exclude_tracking_for :attributes => [:created_at, :updated_at]
end
