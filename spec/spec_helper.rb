$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'active_record'
require 'yaml'
require 'rspec'

RSpec.configure do |config|
  config.before(:each) do
    Contact.delete_all
    Address.delete_all
    Yesterday::Changeset.delete_all
  end
end

$enabled = false

ActiveSupport::Notifications.subscribe(/sql/i) do |*args|
  if $enabled
    event = ActiveSupport::Notifications::Event.new(*args)
    puts "SQL #{event.duration}: #{event.payload[:sql]}"
  end
end

def connect(environment)
  conf = YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.establish_connection(conf[environment])
end

# Open ActiveRecord connection
connect('test')

original_stdout = $stdout
$stdout = StringIO.new

begin
  load(File.dirname(__FILE__) + "/schema.rb")
ensure
  $stdout = original_stdout
end

