# Budget is a meta class that is used to calculate summary data
# for all the deliverables on a project.  Think of it akin to:
#  has_many :deliverables
#  belongs_to :project
#
class Budget
  
  attr_reader :project
  
  def initialize(project_id)
    @project = Project.find(project_id)
  end

  # Gets the next due date from the deliverables
  def next_due_date
    del = self.deliverables
    return nil unless del.size > 0

    dates = del.collect(&:due).delete_if { |d| d.blank?}
    
    return dates.sort[0]
  end
  
  # Gets the last due date of the deliverables
  def final_due_date
    del = self.deliverables
    return nil unless del.size > 0

    dates = del.collect(&:due).delete_if { |d| d.blank?}
    
    return dates.sort[-1]    
  end
  
  # Deliverables assigned to this +Budget+
  def deliverables
    return Deliverable.find_all_by_project_id(@project.id)
  end
  
  # Total budget all of the deliverables
  def budget
    return self.deliverables.collect(&:budget).inject { |sum, n| sum + n} || 0.0
  end

  # Amount of the budget spent.  Expressed as as a percentage whole number
  def budget_ratio
    budget = self.budget # cache result
    if budget > 0.0
      return ((self.spent / budget) * 100).round 
    else
      self.progress
    end
  end
  
  # Total amount spent for all the deliverables
  def spent
    self.deliverables.collect(&:spent).inject { |sum, n| sum + n } || 0.0
  end
  
  # Amount of budget left on the deliverables
  def left
    return self.budget - self.spent
  end
  
  # Amount spent over the budget
  def overruns
    if self.left >= 0
      return 0
    else
      return self.left * -1
    end
  end
  
  # Completation progress, expressed as a percentage whole number
  def progress
    return 100 unless self.deliverables.size > 0
    return 100 if self.budget == 0.0
    
    balance = 0.0
    
    self.deliverables.each do |deliverable|
      balance += deliverable.budget * deliverable.progress
    end
    
    return (balance / self.budget).round
  end
  
  # Budget score.  Will range from 100 (everything done with no money spent) to -100 (nothing done, all the money spent)
  def score
    return self.progress - self.budget_ratio
  end
  
  # Total profit of the deliverables.  This is *not* calculated based on the amount spent and total budget but is the total of the profit amount for the deliverables.
  def profit
    return 0.0 unless self.deliverables.size > 0
    
    profit = 0.0
    # Fixed profit
    profit += self.deliverables.collect(&:profit).delete_if { |d| d.blank?}.inject { |sum, n| sum + n } || 0.0

    # Percentage Rate
    self.deliverables.delete_if { |d| d.profit_percent.blank?}.each do |deliverable|
      profit += deliverable.budget * (deliverable.profit_percent.to_f / 100 )
    end
    
    return profit
  end
end
