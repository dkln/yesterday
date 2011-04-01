require 'spec_helper'
require 'yesterday'
require 'models'

describe Yesterday::Model do

  it 'should have mixed in yesterday::model' do
    Report.new.should respond_to :version_number
    Address.new.should_not respond_to :version_number
  end

  it 'should create a new changeset when saved' do
    Yesterday::Changeset.count.should == 0
    Report.create :description => 'bar'
    Yesterday::Changeset.count.should == 1
  end

  it 'should return all related changesets' do
    report = Report.create(:description => 'foo bar')
    report.changesets.size.should == 1
    report.changesets.first.changed_object_type.should == 'Report'
  end

  describe 'returning version numbers' do
    it 'should return version number when new record' do
      report = Report.new(:description => 'foo bar')
      report.version_number.should == 0
    end

    it 'should return version number after first save' do
      report = Report.create(:description => 'foo bar')
      report.version_number.should == 1
    end

    it 'should return version number after update' do
      report = Report.create(:description => 'foo bar')
      report.description = 'foo bar baz'
      report.save!

      report.version_number.should == 2
    end
  end

  describe' returning older versions' do
    it 'should not return and old version when there is no history' do
      Report.new
      Report.version(0).should == nil
    end

    it 'should return a historical item' do
      report = Report.create!(:description => 'bar')
      Report.where(:id => report.id).version(0).should == nil
      Report.where(:id => report.id).version(1).should be_a(Yesterday::VersionedObject)
    end

    describe 'return a historical view of a version' do
      before do
        @report = Report.create!(:description => 'foo')
        @report.update_attributes :description => 'bar'
        @report.update_attributes :description => 'baz'
      end

      it 'using scopes' do
        @report.version_number.should == 3

        Report.where(:id => @report.id).version(3).description.should == 'baz'
        Report.where(:id => @report.id).version(2).description.should == 'bar'
        Report.where(:id => @report.id).version(1).description.should == 'foo'
      end

      it 'using instance method' do
        @report.version(3).description.should == 'baz'
        @report.version(2).description.should == 'bar'
        @report.version(1).description.should == 'foo'
      end
    end
  end

  describe 'diffing two versions' do
    it 'should diff version 1 with version 2' do
      report = Report.create(:description => 'foo bar')
      report.update_attributes :description => 'foo bar baz'

      diff = report.diff_version(1, 2)
      diff.should be_a(Yesterday::VersionedObject)

      diff.description.current.should == 'foo bar baz'
      diff.description.previous.should == 'foo bar'
    end

    it 'should diff version 1 with version 3' do
      report = Report.create(:description => 'foo')
      report.update_attributes :description => 'bar'
      report.update_attributes :description => 'baz'

      diff = report.diff_version(1, 3)
      diff.should be_a(Yesterday::VersionedObject)

      diff.description.current.should == 'baz'
      diff.description.previous.should == 'foo'
    end

    it 'should detect that new associations are created' do
      address1 = Address.new(
        :street => 'street',
        :house_number => 1,
        :zipcode => '1234AA',
        :city => 'ElectricCity',
        :country => 'Netherlands'
      )

      report = Report.create(
        :description => 'foo bar baz',
        :contacts => [
          Contact.create(
            :first_name => 'John',
            :last_name => 'Doe',
            :addresses => [
              address1
            ]
          )
        ]
      )

      report.version_number.should == 1

      address2 = Address.new(
        :street => 'street',
        :house_number => 1,
        :zipcode => '1234AA',
        :city => 'Armadillo',
        :country => 'FooCountry'
      )

      address3 = Address.new(
        :street => 'lane',
        :house_number => 1337,
        :zipcode => '2211AB',
        :city => 'Cougar town',
        :country => 'BarCountry'
      )

      report.contacts.first.addresses = [address1, address2, address3]

      report.save!

      report.version_number.should == 2

      diff = report.diff_version(1, 2)

      diff.contacts.count.should == 1

      diff.contacts.first.addresses.count.should == 3

      diff.contacts.first.addresses.select(&:unmodified?).map(&:id).should == [address1.id]
      diff.contacts.first.addresses.select(&:created?).map(&:id).should == [address2.id, address3.id]
    end

    describe 'association removal' do
      before do
        @report = Report.create(
          :description => 'foo bar baz',
          :contacts => [
            Contact.create(
              :first_name => 'John',
              :last_name => 'Doe',
              :addresses => [
                Address.create(
                  :street => 'street',
                  :house_number => 1,
                  :zipcode => '1234AA',
                  :city => 'ElectricCity',
                  :country => 'Netherlands'
                )
              ]
            )
          ],
          :companies => [
            Company.create(
              :name => 'Test company'
            )
          ]
        )

        @report.version_number.should == 1

        @address1 = Address.new(
          :street => 'street',
          :house_number => 1,
          :zipcode => '1234AA',
          :city => 'Armadillo',
          :country => 'FooCountry'
        )

        @address2 = Address.new(
          :street => 'lane',
          :house_number => 1337,
          :zipcode => '2211AB',
          :city => 'Cougar town',
          :country => 'BarCountry'
        )

        @report.contacts.first.addresses = [@address1, @address2]
        @report.save!

        @report.contacts.first.addresses = [@address1]
        @report.companies.first.addresses = [@address1]
        @report.save!

        @report.version_number.should == 3
      end

      it 'should detect that associations are destroyed when diffing version 2 with 3' do
        diff = @report.diff_version(2, 3)
        diff.contacts.count.should == 1

        diff.contacts.first.addresses.count.should == 2
        diff.contacts.first.addresses.select(&:unmodified?).count.should == 1
        diff.contacts.first.addresses.select(&:destroyed?).count.should == 1

        diff.contacts.first.addresses.select(&:unmodified?).map(&:id).should == [@address1.id]
        diff.contacts.first.addresses.select(&:destroyed?).map(&:id).should == [@address2.id]
      end

      it 'should detect that associations are created when diffing version 1 with 3' do
        diff = @report.diff_version(1, 3)
        diff.contacts.first.should_not respond_to(:addresses)

        diff.contacts.first.addresses.select(&:created?).map(&:id).should == [@address1.id]
      end
    end
  end

end
