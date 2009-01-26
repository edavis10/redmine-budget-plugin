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
        # Need to find the first date for any TimeEntries  #1924
        first_time_entry = TimeEntry.find(:first,
                                          :conditions => ['project_id = (?) AND user_id = (?)', member.project_id, member.user_id],
                                          :order => 'spent_on ASC')
        date_in_effect = first_time_entry.spent_on if first_time_entry
        date_in_effect ||= member.created_on

        rate = Rate.new({
                          :user => member.user,
                          :amount => member.rate,
                          :project => member.project,
                          :date_in_effect => date_in_effect
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
