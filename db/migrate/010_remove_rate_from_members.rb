RateMigrationErrorMessage = "ERROR: The Rate plugin is not installed.  Please install the Rate plugin or downgrade to version 0.1.0 of the Budget plugin."

begin
  require_dependency 'rate'
rescue LoadError
  raise Exception.new(RateMigrationErrorMessage)
end

require_dependency 'user'
require_dependency 'member'

class RemoveRateFromMembers < ActiveRecord::Migration
  def self.up
    self.check_that_rate_plugin_is_installed
    remove_column :members, :rate
  end
  
  def self.down
    self.check_that_rate_plugin_is_installed
    add_column :members, :rate, :decimal, :precision => 15, :scale => 2
  end
  
  def self.check_that_rate_plugin_is_installed
    raise Exception.new(RateMigrationErrorMessage) unless Object.const_defined?("Rate")
  end
end
