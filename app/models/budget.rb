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
  
  def deliverables
    return self.project.deliverables
  end
  
  # TODO
  def spent
  end
  
  # TODO
  def left
  end
  
  # TODO
  def progress
  end
  
  # TODO
  def score
  end
  
  # TODO
  def final_due_date
  end
  
  # TODO
  def profit
  end
end
