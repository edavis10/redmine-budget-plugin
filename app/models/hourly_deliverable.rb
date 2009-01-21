class HourlyDeliverable < Deliverable
  unloadable
  
  # Amount of money spent on the issues.  Determined by the Member's rate and
  # timelogs.
  def spent
    return 0 unless self.issues.size > 0
    total = 0.0
    
    # Get all timelogs assigned
    time_logs = self.issues.collect(&:time_entries).flatten
    
    # Find each Member for their rate
    time_logs.each do |time_log|
      rate = Rate.amount_for(time_log.user, time_log.project, time_log.spent_on)
      total += (rate * time_log.hours) unless rate.nil?
    end
    
    return total
  end
  
  def profit # :nodoc:
    if read_attribute(:profit_percent).nil?
      return super
    else
      return 0.0 if read_attribute(:cost_per_hour).nil? || read_attribute(:total_hours).nil?
      labor = (read_attribute(:cost_per_hour) * read_attribute(:total_hours))
      
      return (read_attribute(:profit_percent).to_f / 100.0) * (labor + self.overhead)
    end
  end
  
  # Budget for the labor, excluding overhead, profit, and materials
  def labor_budget
    return (read_attribute(:cost_per_hour).to_f * read_attribute(:total_hours).to_f) || 0.0
  end

end

