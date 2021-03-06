ActiveRecord::Schema.define(:version => 1) do

  create_table 'reports', :force => true do |t|
    t.string    'description'
    t.datetime  'created_at'
    t.datetime  'updated_at'
  end

  create_table 'contacts', :force => true do |t|
    t.string    'first_name'
    t.string    'middle_name'
    t.string    'last_name'
    t.datetime  'created_at'
    t.datetime  'updated_at'
    t.integer   'report_id'
  end

  create_table 'addresses', :force => true do |t|
    t.string    'street'
    t.string    'house_number'
    t.string    'zipcode'
    t.string    'city'
    t.string    'country'
    t.datetime  'created_at'
    t.datetime  'updated_at'
  end

  create_table 'addresses_contacts', :id => false, :force => true do |t|
    t.integer   'contact_id'
    t.integer   'address_id'
  end

  create_table 'addresses_companies', :id => false, :force => true do |t|
    t.integer   'company_id'
    t.integer   'address_id'
  end

  create_table 'changesets', :force => true do |t|
    t.integer   'changed_object_id'
    t.string    'changed_object_type'
    t.text      'object_attributes'
    t.integer   'version_number'
    t.datetime  'created_at'
    t.datetime  'updated_at'
  end

  create_table 'companies', :force => true do |t|
    t.string    'name'
    t.datetime  'created_at'
    t.datetime  'updated_at'
    t.integer   'report_id'
  end

end
