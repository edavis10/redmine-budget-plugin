class Deliverable < ActiveRecord::Base
  unloadable
  validates_presence_of :subject
  
  belongs_to :project
  has_many :issues

  def assign_issues_by_version(version_id)
    version = Version.find_by_id(version_id)
    return 0 if version.nil? || version.fixed_issues.blank?
    
    version.fixed_issues.each do |issue|
      issue.update_attribute(:deliverable_id, self.id)
    end
    
    return version.fixed_issues.size
  end
  
  def score
    return self.progress - self.budget_ratio
  end
  
  def spent
    0 
  end
  
  # TODO LATER: Shouldn't require the default_done_ratio patch
  def progress
    return 100 unless self.issues.size > 0

    total ||=  self.issues.collect(&:estimated_hours).delete_if {|e| e.nil? }.inject {|sum, n| sum + n} || 0

    return 100 unless total > 0
    balance = 0.0

    self.issues.each do |issue|
      balance += issue.status.default_done_ratio * issue.estimated_hours unless issue.estimated_hours.nil?
    end

    return (balance / total).round
  end
  
  def budget_ratio
    return 0.0 if self.budget.nil? || self.budget == 0.0
    return ((self.spent / self.budget) * 100).round
  end
  
  #
  # These attributes can take a Dollar amount or a %
  #
  def overhead=(v)
    if v.match(/%/)
      # Clear amount since this is a %
      write_attribute(:overhead, nil)
      write_attribute(:overhead_percent, v.gsub(/[% ]/,''))
    else
      # Clear % since this is a dollar amount
      write_attribute(:overhead_percent, nil)
      # Take out $, commas, and spaces
      write_attribute(:overhead, v.gsub(/[$, ]/,''))
    end
  end

  def materials=(v)
    if v.match(/%/)
      # Clear amount since this is a %
      write_attribute(:materials, nil)
      write_attribute(:materials_percent, v.gsub(/[% ]/,''))
    else
      # Clear % since this is a dollar amount
      write_attribute(:materials_percent, nil)
      # Take out $, commas, and spaces
      write_attribute(:materials, v.gsub(/[$, ]/,''))
    end
  end

  def profit=(v)
    if v.match(/%/)
      # Clear amount since this is a %
      write_attribute(:profit, nil)
      write_attribute(:profit_percent, v.gsub(/[% ]/,''))
    else
      # Clear % since this is a dollar amount
      write_attribute(:profit_percent, nil)
      # Take out $, commas, and spaces
      write_attribute(:profit, v.gsub(/[$, ]/,''))
    end
  end
  
  def budget_remaining
    return self.budget - self.spent
  end
  
  def hours_used
    0
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

  
  # Returns true if the deliverable can be edited by user, otherwise false
  def editable_by?(user)
    (user == user && user.allowed_to?(:manage_budget, project))
  end

end
