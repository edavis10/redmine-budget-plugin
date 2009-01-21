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
      
      spent = member_time_entries.collect(&:cost).inject { |sum, n| sum + n}
      hours = member_time_entries.collect(&:hours).inject { |sum, n| sum + n}

      membership << MemberSpent.new({ 
                                      :user => member.user,
                                      :hours => hours,
                                      :spent => spent
                                    }) unless hours == 0.0
    end

    return membership
  end
end
