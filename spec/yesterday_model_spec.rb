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

  describe' returning older versions' do
    it 'should not return and old version when there is no history' do
      Contact.new
      Contact.version(0).should == nil
    end

    it 'should return a historical item' do
      contact = Contact.create!(:first_name => 'foo', :last_name => 'bar')
      Contact.where(:id => contact.id).version(0).should == nil
      Contact.where(:id => contact.id).version(1).should be_a(Yesterday::VersionedObject)
    end

    describe 'return a historical view of a version' do
      before do
        @contact = Contact.create!(:first_name => 'foo', :last_name => 'bar')
        @contact.update_attributes :first_name => 'john', :last_name => 'dough'
        @contact.update_attributes :first_name => 'ronald', :last_name => 'mcdonald'
      end

      it 'using scopes' do
        @contact.version_number.should == 3

        Contact.where(:id => @contact.id).version(2).first_name.should == 'john'
        Contact.where(:id => @contact.id).version(2).last_name.should == 'dough'

        Contact.where(:id => @contact.id).version(1).first_name.should == 'foo'
        Contact.where(:id => @contact.id).version(1).last_name.should == 'bar'
      end

      it 'using instance method' do
        @contact.version(2).first_name.should == 'john'
        @contact.version(2).last_name.should == 'dough'

        @contact.version(1).first_name.should == 'foo'
        @contact.version(1).last_name.should == 'bar'
      end
    end
  end

end
