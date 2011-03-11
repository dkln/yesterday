require 'yesterday/deserializer'

describe Yesterday::Deserializer do
  it 'should deserialize a hash into a structured set of historical item classes' do
    from = {
      'id' => 1,
      'description' => ['Old description', 'New description'],
      'contacts' => [
        {
          'id' => 1,
          'name' => ['Peter', 'Harold'],
          'addresses' => [
            { 'id' => 1,
              'address' => ['Sesamstreet 1', 'Sesamstreet 1'] },
            { 'id' => 2,
              'address' => ['Sesamstreet 2', 'Sesamstreet 2'] }
           ]
        }
      ]
    }

    object = Yesterday::Deserializer.new(from).to_object

    object.description.should == 'New description'
    object.id.should == 1

    object.contacts.should be_a(Array)
    object.contacts.size.should == 1

    object.contacts.first.id.should == 1
    object.contacts.first.name.should == 1
    object.contacts.first.addresses.size.should == 2
    object.contacts.first.addresses.first.address.should == 'Sesamstreet 1'
    object.contacts.first.addresses.last.address.should == 'Sesamstreet 2'
  end
end
