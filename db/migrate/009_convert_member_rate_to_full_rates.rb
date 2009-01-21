RateMigrationErrorMessage = "ERROR: The Rate plugin is not installed.  Please install the Rate plugin or downgrade to version 0.1.0 of the Budget plugin."

begin
  require_dependency 'rate'
rescue LoadError
  raise Exception.new(RateMigrationErrorMessage)
end

require_dependency 'user'
require_dependency 'member'

class ConvertMemberRateToFullRates < ActiveRecord::Migration
  def self.up
    self.check_that_rate_plugin_is_installed
    
    # Add a new Rate object for each Member
    Member.find(:all, :conditions => ['rate IS NOT NULL']).each do |member|
      say_with_time "Converting rate for #{member.user.to_s} - #{member.project.to_s}" do
        rate = Rate.new({
                          :user => member.user,
                          :amount => member.rate,
                          :project => member.project,
                          :date_in_effect => member.created_on
                        })
        rate.save!
      end
    end
    
  end
  
  def self.down
    self.check_that_rate_plugin_is_installed
    raise ActiveRecord::IrreversibleMigration, "Can't move rates back onto the Members"
  end
  
  def self.check_that_rate_plugin_is_installed
    raise Exception.new(RateMigrationErrorMessage) unless Object.const_defined?("Rate")
  end
end
