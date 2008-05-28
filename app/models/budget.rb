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
  
  def next_due_date
    del = self.deliverables
    return nil unless del.size > 0

    dates = del.collect(&:due_date).delete_if { |d| d.blank?}
    
    return dates.sort[0]
  end
  
  def final_due_date
    del = self.deliverables
    return nil unless del.size > 0

    dates = del.collect(&:due_date).delete_if { |d| d.blank?}
    
    return dates.sort[-1]    
  end
  
  def deliverables
    return Deliverable.find_all_by_project_id(@project.id)
  end
  
  def budget
    return self.deliverables.collect(&:budget).inject { |sum, n| sum + n} || 0.0
  end
  
  def budget_ratio
    budget = self.budget # cache result
    if budget > 0.0
      return ((self.spent / budget) * 100).round 
    else
      self.progress
    end
  end
  
  def spent
    self.deliverables.collect(&:spent).inject { |sum, n| sum + n } || 0.0
  end
  
  def left
    return self.budget - self.spent
  end
  
  def overruns
    if self.left >= 0
      return 0
    else
      return self.left * -1
    end
  end
  
  def progress
    return 100 unless self.deliverables.size > 0
    
    balance = 0.0
    
    self.deliverables.each do |deliverable|
      balance += deliverable.budget * deliverable.progress
    end
    
    return (balance / self.budget).round
  end
  
  def score
    return self.progress - self.budget_ratio
  end
  
  # TODO
  def profit
  end
end
