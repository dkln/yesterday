require 'active_support'
require 'active_support/core_ext'
require 'active_record'

require 'yesterday/changeset'
require 'yesterday/versioning'
require 'yesterday/differ'
require 'yesterday/versioned_object_creator'
require 'yesterday/versioned_object'
require 'yesterday/versioned_attribute'
require 'yesterday/model'
require 'yesterday/serializer'
require 'yesterday/version'

ActiveSupport.on_load(:active_record) do
  include Yesterday::Model
end
