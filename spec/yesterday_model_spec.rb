require 'spec_helper'
require 'yesterday'
require 'models'

describe Yesterday::Model do

  it 'should have mixed in yesterday::model' do
    Contact.new.should respond_to :version_number
    Address.new.should_not respond_to :version_number
  end

  it 'should create a new changeset when saved' do
    Yesterday::Changeset.count.should == 0
    Contact.create :first_name => 'foo', :last_name => 'bar'
    Yesterday::Changeset.count.should == 1
  end

  it 'should return all related changesets' do
    contact = Contact.create(:first_name => 'foo', :last_name => 'bar')
    contact.changesets.size.should == 1
    contact.changesets.first.changed_object_type.should == 'Contact'
  end

  describe 'returning version numbers' do
    it 'should return version number when new record' do
      contact = Contact.new(:first_name => 'foo', :last_name => 'bar')
      contact.version_number.should == 0
    end

    it 'should return version number after first save' do
      contact = Contact.create(:first_name => 'foo', :last_name => 'bar')
      contact.version_number.should == 1
    end

    it 'should return version number after update' do
      contact = Contact.create(:first_name => 'foo', :last_name => 'bar')
      contact.last_name = 'baz'
      contact.save!

      contact.version_number.should == 2
    end
  end

end
