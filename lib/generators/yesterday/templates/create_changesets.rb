class CreateChangesets < ActiveRecord::Migration
  def self.up
    create_table :changesets do |t|
      t.integer :changed_object_id
      t.string :changed_object_type
      t.text :object_attributes
      t.integer :version_number
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :changesets, [ :changed_object_id, :changed_object_type ]
    add_index :changesets, [ :changed_object_id, :changed_object_type, :version_number ]
  end

  def self.down
    drop_table :changesets
  end
end

