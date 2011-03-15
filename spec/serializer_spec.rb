require 'yesterday'

describe Yesterday::Serializer do
  it 'should serialize an activerecord object to a hash' do
    contact = Contact.create(:first_name => 'foo', :last_name => 'bar')

    address1 = Address.create(
      :street => 'street',
      :house_number => 1,
      :zipcode => '1234AA',
      :city => 'Armadillo',
      :country => 'FooCountry'
    )

    address2 = Address.create(
      :street => 'lane',
      :house_number => 1337,
      :zipcode => '2211AB',
      :city => 'Cougar town',
      :country => 'BarCountry'
    )

    contact.addresses << address1
    contact.addresses << address2

    Yesterday::Serializer.new(contact).to_hash.should == {
      'id' => contact.id,
      'first_name' => 'foo',
      'middle_name' => nil,
      'last_name' => 'bar',
      'created_at' => contact.created_at,
      'updated_at' => contact.updated_at,
      'addresses' => [
        {
          'id' => address1.id,
          'street' => 'street',
          'house_number' => 1,
          'zipcode' => '1234AA',
          'city' => 'Armadillo',
          'country' => 'FooCountry',
          'created_at' => address1.created_at,
          'updated_at' => address1.updated_at
        },
        {
          'id' => address2.id,
          'street' => 'lane',
          'house_number' => 1337,
          'zipcode' => '2211AB',
          'city' => 'Cougar town',
          'country' => 'BarCountry',
          'created_at' => address2.created_at,
          'updated_at' => address2.updated_at
        }
      ]
    }
  end
end
