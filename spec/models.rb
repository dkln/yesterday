class Contact < ActiveRecord::Base
  has_and_belongs_to_many :addresses
  tracks_changes
end

class Address < ActiveRecord::Base
end

class Company < ActiveRecord::Base
  tracks_changes
  exclude_tracking_for :attributes => [:created_at, :updated_at]
end
