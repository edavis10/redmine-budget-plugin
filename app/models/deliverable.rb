# A Deliverable is an item that is created as part of the project.  These items
# contain a collection of issues.
class Deliverable < ActiveRecord::Base
  unloadable
  validates_presence_of :subject
  
  belongs_to :project
  has_many :issues

  # Assign all the issues with +version_id+ to this Deliverable
  def assign_issues_by_version(version_id)
    version = Version.find_by_id(version_id)
    return 0 if version.nil? || version.fixed_issues.blank?
    
    version.fixed_issues.each do |issue|
      issue.update_attribute(:deliverable_id, self.id)
    end
    
    return version.fixed_issues.size
  end

  # Change the Deliverable type to another type. Valid types are
  #
  # * FixedDeliverable
  # * HourlyDeliverable
  def change_type(to)
    if [FixedDeliverable.name, HourlyDeliverable.name].include?(to)
      self.type = to
      self.save!
      return Deliverable.find(self.id)
    else
      return self
    end
  end
  
  # Adjusted score to show the status of the Deliverable.  Will range from 100
  # (everything done with no money spent) to -100 (nothing done, all the money spent)
  def score
    return self.progress - self.budget_ratio
  end
  
  # Amount spent.  Virtual accessor that is overriden by subclasses.
  def spent
    0 
  end
  
  # Percentage of the deliverable that is compelte based on the progress of the
  # assigned issues.  Currently requires the +default_done_ratio+ patch.
  def progress
    # TODO LATER: Shouldn't require the default_done_ratio patch
    return 0 unless self.issues.size > 0

    total ||=  self.issues.collect(&:estimated_hours).delete_if {|e| e.nil? }.inject {|sum, n| sum + n} || 0

    return 0 unless total > 0
    balance = 0.0

    self.issues.each do |issue|
      balance += issue.status.default_done_ratio * issue.estimated_hours unless issue.estimated_hours.nil?
    end

    return (balance / total).round
  end
  
  # Amount of the budget spent.  Expressed as as a percentage whole number
  def budget_ratio
    return 0.0 if self.budget.nil? || self.budget == 0.0
    return ((self.spent / self.budget) * 100).round
  end
  
  def overhead
    return read_attribute(:overhead) unless read_attribute(:overhead).nil?
    return ((read_attribute(:overhead_percent).to_f / 100.0) * self.labor_budget) unless read_attribute(:overhead_percent).nil?
    return 0
  end
  
  # Setter for the overhead to take an Dollar amount or a %.
  def overhead=(v)
    return if v.nil?

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

  # Setter for the materials to take an Dollar amount or a %.
  def materials=(v)
    return if v.nil?

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

  # Setter for the profit to take an Dollar amount or a %.  
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
  
  # Amount of the budget remaining to be spent
  def budget_remaining
    return self.budget - self.spent
  end
  
  # Number of hours used.  Virtual accessor that is overriden by subclasses.
  def hours_used
    0
  end
  
  # Amount spent on members.  Virtual accessor that is overriden by subclasses.
  def members_spent
    []
  end
  
  # Amount of the budget remaining
  def left
    return self.budget - self.spent
  end
  
  # Amount spent over the total budget
  def overruns
    if self.left >= 0
      return 0
    else
      return self.left * -1
    end
  end

  # Budget of labor, without counting profit or overheads.  Virtual accessor that is overriden by subclasses.
  def labor_budget
    0
  end

  # Helper method to return an Hash of the trackers and number of issues assigned to each tracker.
  def issues_with_trackers
    trackers = self.project.trackers
    return { } if trackers.empty?
    
    tracker_map = { }
    
    trackers.each do |tracker|
      tracker_map[tracker.name] = Issue.find_all_by_tracker_id_and_project_id_and_deliverable_id(tracker.id, self.project.id, self.id).size
    end

    return tracker_map
  end
  
  # Returns true if the deliverable can be edited by user, otherwise false
  def editable_by?(user)
    (user == user && user.allowed_to?(:manage_budget, project))
  end

end
