RateMigrationErrorMessage = "ERROR: The Rate plugin is not installed.  Please install the Rate plugin or downgrade to version 0.1.0 of the Budget plugin."

begin
  require_dependency 'rate'
rescue LoadError
  raise Exception.new(RateMigrationErrorMessage)
end

class ConvertMemberRateToFullRates < ActiveRecord::Migration
  def self.up
    self.check_that_rate_plugin_is_installed
  end
  
  def self.down
    self.check_that_rate_plugin_is_installed
  end
  
  def self.check_that_rate_plugin_is_installed
    raise Exception.new(RateMigrationErrorMessage) unless Object.const_defined?("Rate")
  end
end
