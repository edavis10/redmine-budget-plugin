# Plain Ruby class to help build a data structure that lists
# each member and the amount of time and money they spent.
class MemberSpent
  attr_accessor :user
  attr_accessor :hours
  attr_accessor :spent
  
  # New data structure to hold the Member's data
  def initialize(options = { })
    self.user = options[:user] || nil
    self.hours = options[:hours] || 0.0
    self.spent = options[:spent] || 0.0
  end

  # Get all the Members, their hours used, and their money spent
  def self.find_all_by_deliverable(deliverable)
    membership = []
    return membership unless deliverable.issues.size > 0
    
    
    project = deliverable.project
    time_entries = deliverable.issues.collect(&:time_entries).flatten
    
    
    project.members.each do |member|
      member_time_entries = time_entries.select { |tl| tl.user_id == member.user.id}
      
      spent = 0.0
      hours = 0.0

      member_time_entries.each do |time_entry|
        rate = Rate.amount_for(time_entry.user, time_entry.project, time_entry.spent_on.to_s)
        spent += time_entry.hours.to_f * rate unless rate.nil?
        hours += time_entry.hours
      end
      
      membership << MemberSpent.new({ 
                                      :user => member.user,
                                      :hours => hours,
                                      :spent => spent
                                    }) unless hours == 0.0
    end

    return membership
  end
end
