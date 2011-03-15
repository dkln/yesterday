require 'active_support'
require 'active_support/core_ext'
require 'active_record'

require 'yesterday/active_record_diff'
require 'yesterday/changeset'
require 'yesterday/differ'
require 'yesterday/hash_to_object'
require 'yesterday/historical_item'
require 'yesterday/historical_value'
require 'yesterday/model'
require 'yesterday/serializer'
require 'yesterday/version'

ActiveSupport.on_load(:active_record) do
  include Yesterday::Model
end
