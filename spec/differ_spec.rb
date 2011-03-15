require 'yesterday'

describe Yesterday::Differ do
  it 'should detect changes' do
    from = {
      'id' => 1,
      'description' => 'Some description',
      'contacts' => [
        {
          'id' => 1,
          'name' => 'Harold',
          'addresses' => [
            { 'id' => 1,
              'address' => 'Sesamstreet 1' },
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        }
      ]
    }

    to = {
      'id' => 1,
      'description' => 'Other description',
      'contacts' => [
        {
          'id' => 1,
          'name' => 'Peter',
          'addresses' => [
            { 'id' => 1,
              'address' => 'Foobar 1' },
            { 'id' => 2,
              'address' => 'Foobar 2' }
          ]
        }
      ]
    }

    Yesterday::Differ.new(from, to).diff.should == {
      'id' => 1,
      'description' => ['Some description', 'Other description'],
      'contacts' => [
        {
          'id' => 1,
          'name' => ['Harold', 'Peter'],
          'addresses' => [
            { 'id' => 1,
              'address' => ['Sesamstreet 1', 'Foobar 1'] },
            { 'id' => 2,
              'address' => ['Sesamstreet 2', 'Foobar 2'] }
           ]
        }
      ]
    }
  end

  it 'should detect destroyed items' do
    from = {
      'id' => 1,
      'description' => 'Some description',
      'contacts' => [
        {
          'id' => 1,
          'name' => 'Harold',
          'addresses' => [
            { 'id' => 1,
              'address' => 'Sesamstreet 1' },
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        },
        {
          'id' => 2,
          'name' => 'Peter',
          'addresses' => [
            { 'id' => 1,
              'address' => 'Sesamstreet 1' },
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        }
      ]
    }

    to = {
      'id' => 1,
      'description' => 'Some description',
      'contacts' => [
        {
          'id' => 1,
          'name' => 'Harold',
          'addresses' => [
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        }
      ]
    }

    Yesterday::Differ.new(from, to).diff.should == {
      'id' => 1,
      'description' => ['Some description', 'Some description'],
      'contacts' => [
        {
          'id' => 1,
          'name' => ['Harold', 'Harold'],
          'addresses' => [
            { 'id' => 2,
              'address' => ['Sesamstreet 2', 'Sesamstreet 2'] }
           ],
           'destroyed_addresses' => [
              { 'id' => 1,
                'address' => 'Sesamstreet 1' }
           ]
        }
      ],
      'destroyed_contacts' => [
        {
          'id' => 2,
          'name' => 'Peter',
          'addresses' => [
            { 'id' => 1,
              'address' => 'Sesamstreet 1' },
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        }
      ]
    }
  end

  it 'should detect created items' do
    from = {
      'id' => 1,
      'description' => 'Some description',
      'contacts' => [
        {
          'id' => 1,
          'name' => 'Harold',
          'addresses' => [
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        }
      ]
    }

    to = {
      'id' => 1,
      'description' => 'Some description',
      'contacts' => [
        {
          'id' => 1,
          'name' => 'Harold',
          'addresses' => [
            { 'id' => 1,
              'address' => 'Sesamstreet 1' },
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        },
        {
          'id' => 2,
          'name' => 'Peter',
          'addresses' => [
            { 'id' => 1,
              'address' => 'Sesamstreet 1' },
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        }
      ]
    }

    Yesterday::Differ.new(from, to).diff.should == {
      'id' => 1,
      'description' => ['Some description', 'Some description'],
      'contacts' => [
        {
          'id' => 1,
          'name' => ['Harold', 'Harold'],
          'addresses' => [
            { 'id' => 2,
              'address' => ['Sesamstreet 2', 'Sesamstreet 2'] }
           ],
           'created_addresses' => [
              { 'id' => 1,
                'address' => 'Sesamstreet 1' }
           ]
        }
      ],
      'created_contacts' => [
        {
          'id' => 2,
          'name' => 'Peter',
          'addresses' => [
            { 'id' => 1,
              'address' => 'Sesamstreet 1' },
            { 'id' => 2,
              'address' => 'Sesamstreet 2' }
           ]
        }
      ]
    }
  end
end
