class Report < ActiveRecord::Base
  has_many :contacts
  has_many :companies

  track_changes
end

class Contact < ActiveRecord::Base
  has_and_belongs_to_many :addresses
end

class Address < ActiveRecord::Base
end

class Company < ActiveRecord::Base
  has_and_belongs_to_many :addresses

  track_changes
  exclude_tracking_for :attributes => [:created_at, :updated_at]
end
