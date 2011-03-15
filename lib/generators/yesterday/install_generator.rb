require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module Yesterday
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    extend ActiveRecord::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates a migration to add the changesets table in order to use tracks_changes in your models'
    def create_migration_file
      migration_template 'create_changesets.rb', 'db/migrate/create_changesets.rb'
    end
  end
end

