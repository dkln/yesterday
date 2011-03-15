require 'spec_helper'
require 'yesterday'
require 'models'

describe Yesterday::Model do

  it 'should have mixed in yesterday::model' do
    Contact.new.should respond_to :version_number
    Address.new.should_not respond_to :version_number
  end

  it 'should create a new changeset when saved' do

  end

end

