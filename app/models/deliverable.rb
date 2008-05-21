class Deliverable < ActiveRecord::Base
  unloadable
  validates_presence_of :subject
  
  belongs_to :project

  attr_accessor :overhead
  attr_accessor :materials
  attr_accessor :profit
  attr_accessor :cost_per_hour
  attr_accessor :total_hours
  attr_accessor :fixed_cost
  
  # TODO: mocked
  def score
    0
  end
  
  # TODO: mocked
  def spent
    0
  end
  
  # TODO: mocked
  def progress
    0
  end
end
