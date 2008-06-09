class MemberSpent
  attr_accessor :user
  attr_accessor :hours
  attr_accessor :spent
  
  def initialize(options = { })
    self.user = options[:user] || nil
    self.hours = options[:hours] || 0.0
    self.spent = options[:spent] || 0.0
  end

  def self.find_all_by_deliverable(deliverable)
    membership = []
    return membership unless deliverable.issues.size > 0
    
    
    project = deliverable.project
    time_entries = deliverable.issues.collect(&:time_entries).flatten
    
    
    project.members.each do |member|
      member_time_entries = time_entries.select { |tl| tl.user_id == member.user.id}
      hours = member_time_entries.collect(&:hours).sum || 0.0

      unless member.rate.nil?
        spent = hours.to_f * member.rate
      else
        spent = 0.0
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
