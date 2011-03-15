require 'yesterday'

describe Yesterday::VersionedObjectCreator do
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

    object = Yesterday::VersionedObjectCreator.new(from).to_object

    require 'pp'

    object.description.current.should == 'New description'
    object.id.should == 1

    object.contacts.should be_a(Array)
    object.contacts.size.should == 1

    object.contacts.first.id.should == 1
    object.contacts.first.name.to_s.should == 'Harold'
    object.contacts.first.name.previous.should == 'Peter'
    object.contacts.first.addresses.size.should == 2
    object.contacts.first.addresses.first.address.previous.should == 'Sesamstreet 1'
    object.contacts.first.addresses.first.address.current.should == 'Sesamstreet 1'
    object.contacts.first.addresses.last.address.previous.should == 'Sesamstreet 2'
    object.contacts.first.addresses.last.address.current.should == 'Sesamstreet 2'
  end
end
