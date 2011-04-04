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
      ],
      'state' => {
        'id' => 1,
        'code' => 'C00',
        'description' => 'Critical'
      }
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
      ],
      'state' => {
        'id' => 1,
        'code' => 'C12',
        'description' => 'Non critical'
      }
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
              'address' => ['Sesamstreet 1', 'Foobar 1'],
              '_event' => 'modified' },
            { 'id' => 2,
              'address' => ['Sesamstreet 2', 'Foobar 2'],
              '_event' => 'modified' }
           ],
          '_event' => 'modified'
        }
      ],
      'state' => {
        'id' => 1,
        'code' => ['C00', 'C12'],
        'description' => ['Critical', 'Non critical'],
        '_event' => 'modified'
      },
      '_event' => 'modified'
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
              'address' => ['Sesamstreet 2', 'Sesamstreet 2'] },
            { 'id' => 1,
              'address' => 'Sesamstreet 1',
              '_event' => 'destroyed' }
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
           ],
          '_event' => 'destroyed'
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
      ],
      'companies' => [
        {
          'id' => 1,
          'name' => 'Some company',
          'contacts' => [
            {
              'id' => 1,
              'name' => 'Some contact'
            }
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
      ],
      'companies' => [
        {
          'id' => 1,
          'name' => 'Some company',
          'contacts' => [
            {
              'id' => 1,
              'name' => 'Some contact'
            },
            {
              'id' => 2,
              'name' => 'Some other contact'
            }
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
              'address' => ['Sesamstreet 2', 'Sesamstreet 2'] },
            { 'id' => 1,
              'address' => 'Sesamstreet 1',
              '_event' => 'created' }
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
           ],
          '_event' => 'created'
        }
      ],
      'companies' => [
        {
          'id' => 1,
          'name' => ['Some company', 'Some company'],
          'contacts' => [
            {
              'id' => 1,
              'name' => ['Some contact', 'Some contact']
            },
            {
              'id' => 2,
              'name' => 'Some other contact',
              '_event' => 'created'
            }
          ]
        }
      ]
    }
  end
end
